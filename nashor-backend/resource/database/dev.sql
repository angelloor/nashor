1. Utilizar la ruta entityBackendGenerate
2. Verificar .network
3. Verificar .controller
4. Verificar .class
5. Verificar .store
6. Verificar .data
7. Copiar crud modified
8. Copiar view_inner_join


select * from dev.utils_get_columns_alias('core', 'academic')
select * from dev.utils_get_columns_type('core', 'academic')







select * from business.view_task
delete from business.task t where t.id_task = 3
update business.task set type_status_task = 'progress', type_action_task = 'received' where id_task = 2