package accesscontrol

import (
    "std"
    "gno.land/p/demo/avl"
)

type IAccessControl interface {
    HasRole(role string, account std.Address) bool
    GetRoleAdmin(role string) string
    GrantRole(role string, account std.Address)
    RevokeRole(role string, account std.Address)
}

type RoleData struct {
    hasRole *avl.Tree
    adminRole string
    isActive bool
}

type AccessControl struct {
    roles *avl.Tree
    defaultAdminRole string
}

// NewAccessControl creates a new instance of AccessControl
func NewAccessControl() *AccessControl {
    return &AccessControl{
        roles: avl.NewTree(),
        defaultAdminRole: "", // Empty role by default
    }
}

// HasRole checks if an account has a role
func (ac *AccessControl) HasRole(role string, account std.Address) bool {
    value, ok := ac.roles.Get(role)

    if ok {
        roleData := value.(RoleData)
        return roleData.isActive && roleData.hasRole.Has(account.String())
    }

    return false
}

// GrantRole grants a role to an account
func (ac *AccessControl) GrantRole(role string, account std.Address) {
    if !ac.HasRole(ac.GetRoleAdmin(role), std.PrevRealm().Addr()) {
        panic("accesscontrol: caller must have admin role to grant")
    }

    value, ok := ac.roles.Get(role)

    if !ok {
        ac.roles.Set(role, RoleData{avl.NewTree(), ac.defaultAdminRole, true})
        value, _ = ac.roles.Get(role)
    }

    roleData := value.(RoleData)
    roleData.hasRole.Set(account.String(), true)
}

// RevokeRole revokes a role from an account
func (ac *AccessControl) RevokeRole(role string, account std.Address) {
    if !ac.HasRole(ac.GetRoleAdmin(role), std.PrevRealm().Addr()) {
        panic("accesscontrol: caller must have admin role to revoke")
    }

    value, ok := ac.roles.Get(role)

    if ok {
        roleData := value.(RoleData)
        roleData.isActive = false
        ac.roles.Set(role, roleData)
    }
}

// GetRoleAdmin returns the admin role of a role
func (ac *AccessControl) GetRoleAdmin(role string) string {
    value, ok := ac.roles.Get(role)

    if ok {
        roleData := value.(RoleData)
        return roleData.adminRole
    }

    return ""
}

// SetRoleAdmin sets the admin role of a role
func (ac *AccessControl) SetRoleAdmin(role string, adminRole string) {
    if !ac.HasRole(ac.GetRoleAdmin(role), std.PrevRealm().Addr()) {
        panic("accesscontrol: caller must have admin role to set admin role")
    }

    value, ok := ac.roles.Get(role)

    if ok {
        roleData := value.(RoleData)
        roleData.adminRole = adminRole
    }
}