select dev.dml_reset_sequences('core');
select dev.dml_truncate_all('core');
select dev.dml_create_initial_data();

select dev.dml_reset_sequences('business');
select dev.dml_truncate_all('business');

select * from business.dml_area_create(1, 1, 'Talento humano', 'Area de talento humano', false);
select * from business.dml_area_create(1, 1, 'Administrativo', 'Area de administrativo', false);
select * from business.dml_area_create(1, 1, 'TICS', 'Area de tecnologias', false);

select * from business.dml_position_create(1, 1, 'Analista', 'Cargo de analista', false);
select * from business.dml_position_create(1, 1, 'Director', 'Cargo de director', false);
select * from business.dml_position_create(1, 1, 'Secretaria', 'Cargo de tecnico', false);

select * from business.dml_attached_create(1, 1, 'Cedula', 'Copia de la cedula', 2, true, false);


select * from business.dml_control_create(1, 1, 'textArea', 'Para que quiere los materiales', 'motivo', '', true, 1, 150, 'Ingrese el motivo', true, '[]', true, false);
select * from business.dml_control_create(1, 1, 'textArea', 'Tienes que justificar', 'justificacion', '', true, 1, 150, 'Ingrese la justificacion', true, '[]', true, false);
select * from business.dml_control_create(1, 1, 'input', 'Ingrese la respuesta', 'respuesta', '', false, 1, 150, 'Ingrese la respuesta', true, '[]', true, false);
select * from business.dml_control_create(1, 1, 'input', 'Ingrese la confirmacion', 'confirmacion', '', false, 1, 150, 'Ingrese la confirmacion', true, '[]', true, false);
select * from business.dml_control_create(1, 1, 'textArea', 'Ingrese la aprobacion', 'aprobacion', '', false, 1, 150, 'Ingrese la aprobacion', true, '[]', true, false);

select * from business.dml_documentation_profile_create(1, 1, 'Solicitud de materiales', 'Perfil de documentacion para la solicitud de materiales', true, false);

select * from business.dml_documentation_profile_attached_create(1, 1 ,1);

select * from business.dml_item_category_create(1, 1, 'Equipos de informatica', 'Categoria para Equipos de informatica', false);

select * from business.dml_item_create(1, 1, 1, 'Mouse', 'Este es un mouse', '5', false);
select * from business.dml_item_create(1, 1, 1, 'Teclado', 'Este es un teclado', '10', false);
select * from business.dml_item_create(1, 1, 1, 'Impresora', 'Esta es una impresora', '15', false);


select * from business.dml_template_create(1, 1, 1, true, true, 'SM (Nivel 1)', 'Plantilla para el nivel 1 de solicitud de materiales', true, '2022-07-14 14:41:23.053169', false, false);
select * from business.dml_template_create(1, 1, 1, false, true, 'SM (Nivel 2)', 'Plantilla para el nivel 2 de solicitud de materiales', true, '2022-07-14 14:58:09.283', false, false);
select * from business.dml_template_create(1, 1, 1, false, true, 'SM (nivel 3)', 'Plantilla para el nivel 3 de solicitud de materiales', true, '2022-07-14 15:15:31.320818', false, false);
select * from business.dml_template_create(1, 1, 1, false, true, 'SM (Nivel 4)', 'Plantilla para el nivel 4 de solicitud de materiales', true, '2022-07-14 15:10:09.216223', false, false);
select * from business.dml_template_create(1, 1, 1, false, true, 'SM (Nivel 5)', 'Plantilla para el nivel 5 de solicitud de materiales', true, '2022-07-14 15:11:00.383672', false, false);


select * from business.dml_template_control_create(1, 1, 1, 1);
select * from business.dml_template_control_create(1, 2, 2, 2);
select * from business.dml_template_control_create(1, 4, 4, 4);
select * from business.dml_template_control_create(1, 5, 5, 5);
select * from business.dml_template_control_create(1, 3, 3, 3);


select * from business.dml_level_profile_create(1, 1, 'Perfil talento humano', 'Perfil para talento humano', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil TICS', 'Perfil para TICS', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Administrativo', 'Perfil para administrativo', false);

select * from business.dml_level_status_create(1, 1, 'Iniciado', 'Estado iniciado', '#e53935', false);
select * from business.dml_level_status_create(1, 1, 'En proceso', 'Estado en proceso', '#fdd835', false);
select * from business.dml_level_status_create(1, 1, 'Finalizado', 'Estado de finalizado', '#2e7d32', false);

select * from business.dml_level_create(1, 1, 1, 2, '1', 'Nivel 1', 'Este es el nivel 1', false);
select * from business.dml_level_create(1, 1, 2, 1, '1', 'Nivel 2', 'Este es el nivel 2', false);
select * from business.dml_level_create(1, 1, 3, 3, '2', 'Nivel 3', 'Este es el nivel 3', false);
select * from business.dml_level_create(1, 1, 4, 1, '3', 'Nivel 4', 'Este es el nivel 4', false);
select * from business.dml_level_create(1, 1, 5, 2, '3', 'Nivel 5', 'Este es el nivel 5', false);



select * from business.dml_process_type_create(1, 1, 'Solicitud de materiales', 'Tipo de proceso para solicitud de materiales', 'SM', 1, false);

select * from business.dml_flow_create(1, 1, 1, 'Solicitud de materiales', 'Flujo para la solicitud de materiales', false);

select * from business.dml_flow_version_create(1, 1, 1, true, '2022-07-14 14:57:25.828', false);

select * from business.dml_flow_version_level_create(1, 1, 1, 1, 0, 'level', '0', '==', '', false, 3, 62);
select * from business.dml_flow_version_level_create(1, 1, 2, 2, 1, 'level', '0', '==', '', false, 264, 63);
select * from business.dml_flow_version_level_create(1, 1, 3, 3, 2, 'level', '0', '==', '', false, 549, 61);
select * from business.dml_flow_version_level_create(1, 1, 4, 5, 4, 'level', '0', '==', '', false, 361, 416);
select * from business.dml_flow_version_level_create(1, 1, 5, 6, 4, 'level', '0', '==', '', true, 726, 412);
select * from business.dml_flow_version_level_create(1, 1, 3, 4, 3, 'conditional', '3' , '==', '1', false, 557, 239);


select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);


select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);

select * from core.dml_person_create(1, 2, 2, '9999999999991', 'Tania', 'Rogel', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 3, 3, '9999999999992', 'Beto', 'Aldas', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 4, 4, '9999999999993', 'Lorena', 'Altamirano', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 5, 5, '9999999999994', 'Jocasta', 'Chango', 'PUYO', '+593', false);

select * from core.dml_user_create(1, 1, 2, 1, 'tania@nashor.com', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 3, 1, 'beto@nashor.com', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 4, 1, 'lorena@nashor.com', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 5, 1, 'jocasta@nashor.com', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);

select * from business.dml_official_create(1, 1, 2, 1, 2, false);
select * from business.dml_official_create(1, 1, 3, 3, 1, false);
select * from business.dml_official_create(1, 1, 4, 1, 1, false);
select * from business.dml_official_create(1, 1, 5, 2, 3, false);

select * from business.dml_level_profile_official_create(1, 1, 1, true);
select * from business.dml_level_profile_official_create(1, 1, 3, false);
select * from business.dml_level_profile_official_create(1, 2, 2, true);
select * from business.dml_level_profile_official_create(1, 3, 4, false);