begin;

do $$
begin
    if to_regclass('mcr.migration_map') is not null then
        execute $sql$
            delete from system.sys_user_role_scope scope
            using mcr.migration_map map
            where (
                    (map.source_table = 'MCR_User' and scope.user_id = map.target_id)
                 or (map.source_table = 'MCR_Role' and scope.role_id = map.target_id)
                 or (map.source_table = 'MCR_Hospital' and scope.hospital_id = map.target_id)
                 or (map.source_table = 'MCR_Department' and scope.department_id = map.target_id)
              )
              and not exists (
                  select 1 from system.sys_user preserved_user
                  where preserved_user.id = scope.user_id
              )
        $sql$;

        execute $sql$
            delete from system.sys_map_user_role user_role
            using mcr.migration_map map
            where (
                    (map.source_table = 'MCR_User' and user_role.user_id = map.target_id)
                 or (map.source_table = 'MCR_Role' and user_role.role_id = map.target_id)
              )
              and not exists (
                  select 1 from system.sys_user preserved_user
                  where preserved_user.id = user_role.user_id
              )
        $sql$;

        execute $sql$
            delete from system.sys_map_role_permission role_permission
            using mcr.migration_map map
            where (map.source_table = 'MCR_Role' and role_permission.role_id = map.target_id)
               or (map.source_table = 'MCR_FunctionPower' and role_permission.permission_id = map.target_id)
        $sql$;

        execute $sql$
            delete from system.sys_department department
            using mcr.migration_map map
            where map.source_table = 'MCR_Department'
              and department.id = map.target_id
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.department_id = department.id
              )
        $sql$;

        execute $sql$
            delete from system.sys_hospital hospital
            using mcr.migration_map map
            where map.source_table = 'MCR_Hospital'
              and hospital.id = map.target_id
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.hospital_id = hospital.id
              )
              and not exists (
                  select 1 from system.sys_department department
                  where department.hospital_id = hospital.id
              )
        $sql$;

        execute $sql$
            delete from system.sys_permission permission
            using mcr.migration_map map
            where map.source_table = 'MCR_FunctionPower'
              and permission.id = map.target_id
              and permission.code like 'Power-MCR-%'
        $sql$;

        execute $sql$
            delete from system.sys_role role_row
            using mcr.migration_map map
            where map.source_table = 'MCR_Role'
              and role_row.id = map.target_id
              and role_row.type = 'MCR'
              and not exists (
                  select 1 from system.sys_map_user_role user_role
                  where user_role.role_id = role_row.id
              )
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.role_id = role_row.id
              )
        $sql$;

    end if;

    if to_regclass('system.sys_user_role_scope') is not null and to_regclass('system.sys_role') is not null then
        execute $sql$
            delete from system.sys_user_role_scope scope
            using system.sys_role role_row
            where scope.role_id = role_row.id
              and role_row.type = 'MCR'
              and not exists (
                  select 1 from system.sys_user preserved_user
                  where preserved_user.id = scope.user_id
              )
        $sql$;
    end if;

    if to_regclass('system.sys_map_user_role') is not null and to_regclass('system.sys_role') is not null then
        execute $sql$
            delete from system.sys_map_user_role user_role
            using system.sys_role role_row
            where user_role.role_id = role_row.id
              and role_row.type = 'MCR'
              and not exists (
                  select 1 from system.sys_user preserved_user
                  where preserved_user.id = user_role.user_id
              )
        $sql$;
    end if;

    if to_regclass('system.sys_map_role_permission') is not null and to_regclass('system.sys_role') is not null then
        execute $sql$
            delete from system.sys_map_role_permission role_permission
            using system.sys_role role_row
            where role_permission.role_id = role_row.id
              and role_row.type = 'MCR'
        $sql$;
    end if;

    if to_regclass('system.sys_map_role_permission') is not null and to_regclass('system.sys_permission') is not null then
        execute $sql$
            delete from system.sys_map_role_permission role_permission
            using system.sys_permission permission
            where role_permission.permission_id = permission.id
              and permission.code like 'Power-MCR-%'
        $sql$;
    end if;

    if to_regclass('system.sys_role') is not null then
        execute $sql$
            delete from system.sys_role role_row
            where role_row.type = 'MCR'
              and not exists (
                  select 1 from system.sys_map_user_role user_role
                  where user_role.role_id = role_row.id
              )
              and not exists (
                  select 1 from system.sys_user_role_scope scope
                  where scope.role_id = role_row.id
              )
        $sql$;
    end if;

    if to_regclass('system.sys_permission') is not null then
        execute $sql$
            delete from system.sys_permission
            where code like 'Power-MCR-%'
        $sql$;
    end if;

end
$$;

drop schema if exists mcr cascade;

commit;
