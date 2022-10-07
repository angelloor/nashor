select dev.dml_reset_sequences('core');
select dev.dml_truncate_all('core');
select dev.dml_create_initial_data();

select dev.dml_reset_sequences('business');
select dev.dml_truncate_all('business');

-- Business

select * from core.dml_profile_create(1, 1, 'commonProfile', 'Perfil Administrador', 'Perfil de usuario para el administrador', true, false);
select * from core.dml_profile_create(1, 1, 'commonProfile', 'Perfil Fiscalizador', 'Perfil de usuario para el fiscalizador', true, false);
select * from core.dml_profile_create(1, 1, 'commonProfile', 'Perfil Gestor de inventario', 'Perfil de usuario para el gestor de inventario', true, false);
select * from core.dml_profile_create(1, 1, 'commonProfile', 'Perfil Solicitante', 'Perfil de usuario para el solicitante', true, false);

select * from core.dml_type_user_create(1, 1, 2, 'Administrador', 'Tipo de usuario para el administrador', true, false);
select * from core.dml_type_user_create(1, 1, 3, 'Fiscalizador', 'Tipo de usuario para el fiscalizador', true, false);
select * from core.dml_type_user_create(1, 1, 4, 'Gestor de inventario', 'Tipo de usuario para el gestor de inventario', true, false);
select * from core.dml_type_user_create(1, 1, 5, 'Solicitante', 'Tipo de usuario para el solicitante', true, false);

-- Administrador
select * from core.dml_navigation_create(1, 1, 'Administrador (Por defecto)', 'Navegación por defecto para el administrador', 'defaultNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.area",
				"title": "Area",
				"type": "basic",
				"icon": "heroicons_outline:view-boards",
				"link": "/business/area"
			},
			{
				"id": "business.position",
				"title": "Cargo",
				"type": "basic",
				"icon": "heroicons_outline:collection",
				"link": "/business/position"
			},
			{
				"id": "business.official",
				"title": "Funcionario",
				"type": "basic",
				"icon": "heroicons_outline:user-circle",
				"link": "/business/official"
			},
			{
				"id": "business.plugin-attached",
				"title": "Plugin anexo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.attached",
						"title": "Anexo",
						"type": "basic",
						"icon": "heroicons_outline:link",
						"link": "/business/attached"
					},
					{
						"id": "business.documentation-profile",
						"title": "Perfil de docuemntación",
						"type": "basic",
						"icon": "heroicons_outline:document-text",
						"link": "/business/documentation-profile"
					}
				]
			},
			{
				"id": "business.plugin-item",
				"title": "Plugin articulo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.plugin-item",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/plugin-item"
					},
					{
						"id": "business.item-category",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/item-category"
					},
					{
						"id": "business.item",
						"title": "Artículo",
						"type": "basic",
						"icon": "heroicons_outline:cube",
						"link": "/business/item"
					}
				]
			},
			{
				"id": "business.bpm",
				"title": "BPM",
				"type": "collapsable",
				"icon": "heroicons_outline:cube-transparent",
				"children": [
					{
						"id": "business.level-status",
						"title": "Estado del nivel",
						"type": "basic",
						"icon": "heroicons_outline:status-online",
						"link": "/business/level-status"
					},
					{
						"id": "business.level-profile",
						"title": "Perfil del nivel",
						"type": "basic",
						"icon": "heroicons_outline:user-group",
						"link": "/business/level-profile"
					},
					{
						"id": "business.template",
						"title": "Plantilla",
						"type": "basic",
						"icon": "heroicons_outline:template",
						"link": "/business/template"
					},
					{
						"id": "business.level",
						"title": "Nivel",
						"type": "basic",
						"icon": "heroicons_outline:menu",
						"link": "/business/level"
					},
					{
						"id": "business.flow",
						"title": "Flujo",
						"type": "basic",
						"icon": "mat_outline:account_tree",
						"link": "/business/flow"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Administrador (Compacta)', 'Navegación compacta para el administrador', 'compactNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Administrador (Futurista)', 'Navegación futurista para el administrador', 'futuristicNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.area",
				"title": "Area",
				"type": "basic",
				"icon": "heroicons_outline:view-boards",
				"link": "/business/area"
			},
			{
				"id": "business.position",
				"title": "Cargo",
				"type": "basic",
				"icon": "heroicons_outline:collection",
				"link": "/business/position"
			},
			{
				"id": "business.official",
				"title": "Funcionario",
				"type": "basic",
				"icon": "heroicons_outline:user-circle",
				"link": "/business/official"
			},
			{
				"id": "business.plugin-attached",
				"title": "Plugin anexo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.attached",
						"title": "Anexo",
						"type": "basic",
						"icon": "heroicons_outline:link",
						"link": "/business/attached"
					},
					{
						"id": "business.documentation-profile",
						"title": "Perfil de docuemntación",
						"type": "basic",
						"icon": "heroicons_outline:document-text",
						"link": "/business/documentation-profile"
					}
				]
			},
			{
				"id": "business.plugin-item",
				"title": "Plugin articulo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.plugin-item",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/plugin-item"
					},
					{
						"id": "business.item-category",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/item-category"
					},
					{
						"id": "business.item",
						"title": "Artículo",
						"type": "basic",
						"icon": "heroicons_outline:cube",
						"link": "/business/item"
					}
				]
			},
			{
				"id": "business.bpm",
				"title": "BPM",
				"type": "collapsable",
				"icon": "heroicons_outline:cube-transparent",
				"children": [
					{
						"id": "business.level-status",
						"title": "Estado del nivel",
						"type": "basic",
						"icon": "heroicons_outline:status-online",
						"link": "/business/level-status"
					},
					{
						"id": "business.level-profile",
						"title": "Perfil del nivel",
						"type": "basic",
						"icon": "heroicons_outline:user-group",
						"link": "/business/level-profile"
					},
					{
						"id": "business.template",
						"title": "Plantilla",
						"type": "basic",
						"icon": "heroicons_outline:template",
						"link": "/business/template"
					},
					{
						"id": "business.level",
						"title": "Nivel",
						"type": "basic",
						"icon": "heroicons_outline:menu",
						"link": "/business/level"
					},
					{
						"id": "business.flow",
						"title": "Flujo",
						"type": "basic",
						"icon": "mat_outline:account_tree",
						"link": "/business/flow"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Administrador (Horizontal)', 'Navegación horizontal para el administrador', 'horizontalNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);


select * from core.dml_profile_navigation_create(1, 2, 5);
select * from core.dml_profile_navigation_create(1, 2, 6);
select * from core.dml_profile_navigation_create(1, 2, 7);
select * from core.dml_profile_navigation_create(1, 2, 8);

-- Fiscalizador
select * from core.dml_navigation_create(1, 1, 'Fiscalizador (Por defecto)', 'Navegación por defecto para el fiscalizador', 'defaultNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.plugin-attached",
				"title": "Plugin anexo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.attached",
						"title": "Anexo",
						"type": "basic",
						"icon": "heroicons_outline:link",
						"link": "/business/attached"
					},
					{
						"id": "business.documentation-profile",
						"title": "Perfil de docuemntación",
						"type": "basic",
						"icon": "heroicons_outline:document-text",
						"link": "/business/documentation-profile"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Fiscalizador (Compacta)', 'Navegación compacta para el fiscalizador', 'compactNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Fiscalizador (Futurista)', 'Navegación futurista para el fiscalizador', 'futuristicNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.plugin-attached",
				"title": "Plugin anexo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.attached",
						"title": "Anexo",
						"type": "basic",
						"icon": "heroicons_outline:link",
						"link": "/business/attached"
					},
					{
						"id": "business.documentation-profile",
						"title": "Perfil de docuemntación",
						"type": "basic",
						"icon": "heroicons_outline:document-text",
						"link": "/business/documentation-profile"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Fiscalizador (Horizontal)', 'Navegación horizontal para el fiscalizador', 'horizontalNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);


select * from core.dml_profile_navigation_create(1, 3, 9);
select * from core.dml_profile_navigation_create(1, 3, 10);
select * from core.dml_profile_navigation_create(1, 3, 11);
select * from core.dml_profile_navigation_create(1, 3, 12);

-- Gestor de inventario
select * from core.dml_navigation_create(1, 1, 'Gestor de inventario (Por defecto)', 'Navegación por defecto para el gestor de inventario', 'defaultNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.plugin-item",
				"title": "Plugin articulo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.plugin-item",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/plugin-item"
					},
					{
						"id": "business.item-category",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/item-category"
					},
					{
						"id": "business.item",
						"title": "Artículo",
						"type": "basic",
						"icon": "heroicons_outline:cube",
						"link": "/business/item"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Gestor de inventario (Compacta)', 'Navegación compacta para el gestor de inventario', 'compactNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Gestor de inventario (Futurista)', 'Navegación futurista para el gestor de inventario', 'futuristicNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.plugin-item",
				"title": "Plugin articulo",
				"type": "collapsable",
				"icon": "mat_outline:ballot",
				"children": [
					{
						"id": "business.plugin-item",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/plugin-item"
					},
					{
						"id": "business.item-category",
						"title": "Categoría del artículo",
						"type": "basic",
						"icon": "mat_outline:category",
						"link": "/business/item-category"
					},
					{
						"id": "business.item",
						"title": "Artículo",
						"type": "basic",
						"icon": "heroicons_outline:cube",
						"link": "/business/item"
					}
				]
			},
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	},
	{
		"id": "report",
		"title": "Reportes",
		"subtitle": "Reportes del sistema",
		"type": "basic",
		"link": "/report"
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Gestor de inventario (Horizontal)', 'Navegación horizontal para el gestor de inventario', 'horizontalNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	},
	{
		"id": "report",
		"title": "Reportes",
		"type": "aside",
		"icon": "mat_outline:document",
		"children": []
	}
]', false);


select * from core.dml_profile_navigation_create(1, 4, 13);
select * from core.dml_profile_navigation_create(1, 4, 14);
select * from core.dml_profile_navigation_create(1, 4, 15);
select * from core.dml_profile_navigation_create(1, 4, 16);

-- Solicitante
select * from core.dml_navigation_create(1, 1, 'Solicitante (Por defecto)', 'Navegación por defecto para el solicitante', 'defaultNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Solicitante (Compacta)', 'Navegación compacta para el solicitante', 'compactNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Solicitante (Futurista)', 'Navegación futurista para el solicitante', 'futuristicNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"subtitle": "Administración business del sistema",
		"type": "group",
		"icon": "heroicons_outline:cube-transparent",
		"children": [
			{
				"id": "business.process",
				"title": "Proceso",
				"type": "basic",
				"icon": "heroicons_outline:document",
				"link": "/business/process"
			},
			{
				"id": "business.task",
				"title": "Tarea",
				"type": "basic",
				"icon": "mat_outline:task",
				"link": "/business/task"
			}
		]
	}
]', false);

select * from core.dml_navigation_create(1, 1, 'Solicitante (Horizontal)', 'Navegación horizontal para el solicitante', 'horizontalNavigation', true, '[
	{
		"id": "business",
		"title": "Business",
		"type": "aside",
		"icon": "mat_outline:business",
		"children": []
	}
]', false);


select * from core.dml_profile_navigation_create(1, 5, 17);
select * from core.dml_profile_navigation_create(1, 5, 18);
select * from core.dml_profile_navigation_create(1, 5, 19);
select * from core.dml_profile_navigation_create(1, 5, 20);

-- Business

select * from business.dml_area_create(1, 1, 'TICS', 'Unidad de TICS / Sistemas', false);
select * from business.dml_area_create(1, 1, 'Bodega', 'Unidad de Bodega', false);
select * from business.dml_area_create(1, 1, 'Administrativo', 'Dirección Administrativa', false);
select * from business.dml_area_create(1, 1, 'Compras Públicas', 'Unidad de Compras Públicas', false);
select * from business.dml_area_create(1, 1, 'Alcaldía', 'Alcaldía', false);
select * from business.dml_area_create(1, 1, 'Financiero', 'Dirección Financiera', false);

select * from business.dml_position_create(1, 1, 'Asistente de Tecnologías de la Información', 'Cargo para el Asistente de Tecnologías de la Información', false);
select * from business.dml_position_create(1, 1, 'Administrador de TICS', 'Cargo para el Administrador de TICS', false);
select * from business.dml_position_create(1, 1, 'Guardalmacén General (Delegado)', 'Cargo para el Guardalmacén General (Delegado)', false);
select * from business.dml_position_create(1, 1, 'Director Administrativo', 'Cargo para el Director Administrativo', false);
select * from business.dml_position_create(1, 1, 'Administrador Portal Compras Públicas', 'Cargo para el Administrador Portal Compras Públicas', false);
select * from business.dml_position_create(1, 1, 'Alcalde GAD Municipal Cantón Pastaza', 'Cargo para el Alcalde GAD Municipal Cantón Pastaza', false);
select * from business.dml_position_create(1, 1, 'Directora Financiera', 'Cargo para la Directora Financiera', false);

select * from business.dml_attached_create(1, 1, 'Informe de factibilidad', 'Suba el informe de factibilidad', 2, true, false);
select * from business.dml_attached_create(1, 1, 'información para la adquisición', 'Suba la información para la adquisición', 2, true, false);
select * from business.dml_attached_create(1, 1, 'Partida presupuestaria', 'Suba la partida presupuestaria', 2, true, false);
select * from business.dml_attached_create(1, 1, 'Orden de compra', 'Suba la orden de compra', 2, true, false);

select * from business.dml_documentation_profile_create(1, 1, 'Solicitud', 'Perfil de documentación para la solicitud de materiales', true, false);
select * from business.dml_documentation_profile_create(1, 1, 'Compras públicas (subida)', 'Perfil de documentación para compras públicas (subida)', true, false);
select * from business.dml_documentation_profile_create(1, 1, 'Financiero (partida presupuestaria)', 'Perfil de documentación para Financiero (partida presupuestaria)', true, false);
select * from business.dml_documentation_profile_create(1, 1, 'Compras públicas (orden de compra)', 'Perfil de documentación para Compras públicas (orden de compra)', true, false);

select * from business.dml_documentation_profile_attached_create(1, 1 ,1);
select * from business.dml_documentation_profile_attached_create(1, 2 ,2);
select * from business.dml_documentation_profile_attached_create(1, 3 ,3);
select * from business.dml_documentation_profile_attached_create(1, 4 ,4);

select * from business.dml_plugin_item_create(1, 1, 'Plugin para compras publicas', 'Este plugin es para que compras publicas pueda seleccionar cantidad y poner el CPC', false);
select * from business.dml_plugin_item_column_create(1, 1, 'CANTIDAD', '5');
select * from business.dml_plugin_item_column_create(1, 1, 'CPC', '20');

select * from business.dml_template_create(1, 1, 1, 1, true, true, 'SM - Solicitud', 'Plantilla para la solicitud de materiales', true, '2022-09-22 10:41:23.053169', false, false);
select * from business.dml_template_create(1, 1, 1, 1, false, false, 'SM - Fiscalización equipos informáticos', 'Plantilla para la fiscalización de equipos informáticos', true, '2022-09-22 10:58:09.283', false, false);
select * from business.dml_template_create(1, 1, 1, 1, false, false, 'SM - Revisión (bodega)', 'Plantilla para la revisión de bodega', true, '2022-09-22 10:15:31.320818', false, false);
select * from business.dml_template_create(1, 1, 1, 1, false, false, 'SM - Aprobación Administrativo', 'Plantilla la aprobación de administrativo', true, '2022-09-22 10:10:09.216223', false, false);
select * from business.dml_template_create(1, 1, 2, 1, true, false, 'SM - Compras públicas (subida)', 'Plantilla para la subida de información en compras públicas', true, '2022-09-22 10:11:00.383672', false, false);
select * from business.dml_template_create(1, 1, 1, 1, false, false, 'SM - Alcaldía (autorización proceso)', 'Plantilla la autorización del proceso en alcaldía', true, '2022-09-22 10:11:00.383672', false, false);
select * from business.dml_template_create(1, 1, 3, 1, true, false, 'SM - Financiero (partida presupuestaria)', 'Plantilla para la subida de partida presupuestaria en financiero', true, '2022-09-22 15:11:00.383672', false, false);
select * from business.dml_template_create(1, 1, 1, 1, false, false, 'SM - Alcaldía (autorización compra)', 'Plantilla para la autorización de la compra en alcaldía', true, '2022-09-22 10:11:00.383672', false, false);
select * from business.dml_template_create(1, 1, 4, 1, true, false, 'SM - Compras públicas (orden de compra)', 'Plantilla para la generación de la orden de compra en compras públicas', true, '2022-09-22 10:11:00.383672', false, false);

select * from business.dml_control_create(1, 1, 'radioButton', 'Seleccione el tipo de solicitud', 'tipo_solicitud', '', true, 1, 1, '', false, '[{"name":"Bienes","value":"bienes"},{"name":"Servicios","value":"servicios"}]', true, false);
select * from business.dml_control_create(1, 1, 'radioButton', 'Desea aprobar la entrega?', 'aprobacion_entrega', '', true, 1, 1, '', false, '[{"name":"Si","value":"si"},{"name":"No","value":"no"}]', true, false);
select * from business.dml_control_create(1, 1, 'radioButton', 'Desea aprobar que continue el proceso de compra?', 'aprobacion_proceso', '', true, 1, 1, '', false, '[{"name":"Si","value":"si"},{"name":"No","value":"no"}]', true, false);
select * from business.dml_control_create(1, 1, 'radioButton', 'Hay partida presupuestaria?', 'existencia_partida', '', true, 1, 1, '', false, '[{"name":"Si","value":"si"},{"name":"No","value":"no"}]', true, false);
select * from business.dml_control_create(1, 1, 'radioButton', 'Desea aprobar la compra?', 'aprobacion_proceso_compra', '', true, 1, 1, '', false, '[{"name":"Si","value":"si"},{"name":"No","value":"no"}]', true, false);

select * from business.dml_item_category_create(1, 1, 'Equipos de informática', 'categoría para equipos de informática', false);

select * from business.dml_item_create(1, 1, 1, 'Mouse', 'Este es un mouse', false);
select * from business.dml_item_create(1, 1, 1, 'Teclado', 'Este es un teclado', false);
select * from business.dml_item_create(1, 1, 1, 'Impresora', 'Esta es una impresora', false);

select * from business.dml_template_control_create(1, 2, 1, 1);
select * from business.dml_template_control_create(1, 4, 2, 1);
select * from business.dml_template_control_create(1, 6, 3, 1);
select * from business.dml_template_control_create(1, 7, 4, 1);
select * from business.dml_template_control_create(1, 8, 5, 1);

select * from business.dml_level_profile_create(1, 1, 'Perfil TICS', 'Perfil para TICS', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Bodega', 'Perfil para Bodega', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Administrativo', 'Perfil para Administrativo', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Compras públicas', 'Perfil para Compras públicas ', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Alcaldía', 'Perfil para Alcaldía', false);
select * from business.dml_level_profile_create(1, 1, 'Perfil Financiero', 'Perfil para Financiero', false);

select * from business.dml_level_status_create(1, 1, 'Iniciado', 'Estado iniciado', '#d32f2f', false);
select * from business.dml_level_status_create(1, 1, 'En proceso', 'Estado en proceso', '#ffeb3b', false);
select * from business.dml_level_status_create(1, 1, 'Finalizado', 'Estado de finalizado', '#4caf50', false);

select * from business.dml_level_create(1, 1, 1, 1, '1', 'Solicitud', 'Nivel para la solicitud de materiales', false);
select * from business.dml_level_create(1, 1, 2, 1, '2', 'Fiscalización Equipos informáticos', 'Aquí se encargan de fiscalizar los equipos informáticos', false);
select * from business.dml_level_create(1, 1, 3, 2, '2', 'revisión (Bodega)', 'Aquí bodega revisa si hay los bienes en stock', false);
select * from business.dml_level_create(1, 1, 4, 3, '2', 'aprobación Administrativo', 'Aquí el director administrativo aprueba la entrega de los bienes', false);
select * from business.dml_level_create(1, 1, 5, 4, '2', 'Compras públicas (subida)', 'El departamento de compras públicas recibe la lista de materiales para la adquisición', false);
select * from business.dml_level_create(1, 1, 6, 5, '2', 'Alcaldía (autorización proceso)', 'El Alcalde autoriza que el proceso continue', false);
select * from business.dml_level_create(1, 1, 7, 6, '2', 'Financiero (partida presupuestaria)', 'Financiero verifican la partida presupuestaria', false);
select * from business.dml_level_create(1, 1, 8, 5, '2', 'Alcaldía (autorización compra)', 'El Alcalde autoriza que se efectué la compra', false);
select * from business.dml_level_create(1, 1, 9, 4, '3', 'Compras públicas (orden de compra)', 'Se genera la orden de compra', false);

select * from business.dml_flow_create(1, 1, 'Solicitud de materiales', 'Flujo para solicitud de materiales', 'SM', 'T', 1, false);

CREATE SEQUENCE IF NOT EXISTS business.serial_flow_id_1 INCREMENT 1 MINVALUE  1 MAXVALUE 9999999999 START 1 CACHE 1;

select * from business.dml_flow_version_create(1, 1, 1, true, '2022-09-22 10:57:25.828', false);

select * from business.dml_flow_version_level_create(1, 1, 1, 1, 0, 'level', '0', '==', '', false, 50, 120);
select * from business.dml_flow_version_level_create(1, 1, 2, 2, 1, 'level', '0', '==', '', false, 407, 130);
select * from business.dml_flow_version_level_create(1, 1, 2, 3, 2, 'conditional', '1', '==', 'bienes', false, 422, 315);
select * from business.dml_flow_version_level_create(1, 1, 3, 4, 3, 'level', '0', '==', '', true, 130, 524);
select * from business.dml_flow_version_level_create(1, 1, 5, 5, 3, 'level', '0', '==', '', false, 663, 511);
select * from business.dml_flow_version_level_create(1, 1, 4, 6, 4, 'level', '0', '==', '', false, 126, 750);
select * from business.dml_flow_version_level_create(1, 1, 4, 7, 6, 'conditional', '2', '==', 'si', false, 121, 974);

select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);
select * from core.dml_academic_create(1, '', '', '', false);

select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);
select * from core.dml_job_create(1, '', '', '', '', false);

select * from core.dml_person_create(1, 2, 2, '1600495970', 'Javier David', 'Noboa Pumalema', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 3, 3, '1600369746', 'Alberto Alexander', 'Aldás Villacrés', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 4, 4, '1708237480', 'Mario Segundo', 'Granda', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 5, 5, '1600156952', 'Ricardo Raúl', 'Freire Castillo', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 6, 6, '1715105597', 'Jaime Rolando', 'Gallardo Diaz', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 7, 7, '1600296006', 'Edwin Oswaldo', 'Zuñiga Calderón', 'PUYO', '+593', false);
select * from core.dml_person_create(1, 8, 8, '1803578051', 'Verónica de los Angeles', 'Viteri Fiallos', 'PUYO', '+593', false);

select * from core.dml_user_create(1, 1, 2, 5, 'javier@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 3, 2, 'beto@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 4, 4, 'mario@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 5, 3, 'ricardo@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 6, 3, 'rolando@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 7, 3, 'oswaldo@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);
select * from core.dml_user_create(1, 1, 8, 3, 'veronica@nashor.puyo.gob.ec', 'kCDBvVvdctK+O4iiAprwPQ==', 'default.svg', true, false);

select * from business.dml_official_create(1, 1, 2, 1, 1, false);
select * from business.dml_official_create(1, 1, 3, 1, 2, false);
select * from business.dml_official_create(1, 1, 4, 2, 3, false);
select * from business.dml_official_create(1, 1, 5, 3, 4, false);
select * from business.dml_official_create(1, 1, 6, 4, 5, false);
select * from business.dml_official_create(1, 1, 7, 5, 6, false);
select * from business.dml_official_create(1, 1, 8, 6, 7, false);

select * from business.dml_level_profile_official_create(1, 1, 1, false);
select * from business.dml_level_profile_official_create(1, 1, 2, true);
select * from business.dml_level_profile_official_create(1, 2, 3, true);
select * from business.dml_level_profile_official_create(1, 3, 4, false);
select * from business.dml_level_profile_official_create(1, 4, 5, false);
select * from business.dml_level_profile_official_create(1, 5, 6, false);
select * from business.dml_level_profile_official_create(1, 6, 7, false);