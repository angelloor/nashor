import fs from 'fs';
import path from 'path';
import {
	ddl_create_crud_modified,
	ddl_create_view_inner_table,
	utils_get_alias,
	utils_get_columns_backend,
	utils_get_schema,
	utils_table_exists,
} from './dev.store';
import { BodyBackendGenerate } from './utils/dev.types';
import {
	entityToUpperCase,
	entityToUpperCaseOutInitial,
} from './utils/dev.utils';

export const entityBackendGenerate = (body: BodyBackendGenerate) => {
	return new Promise<string>((resolve, reject) => {
		utils_table_exists(body.scheme, body.entity)
			.then(async (count) => {
				if (count == 1) {
					const basePath = path.join(__dirname, '../');
					let columns: [];
					let externasTables: [];
					let aliasTable: string = '';
					/**
					 * Generate folder for the entity
					 */
					generateFolder(basePath, body.scheme, body.entity);
					/**
					 * Get columns of the entity
					 */

					await utils_get_columns_backend(body.scheme, body.entity)
						.then(async (columnsEntity) => {
							columns = columnsEntity;

							await generateTablesExternal(body.entity, columnsEntity)
								.then((_externasTables: any) => {
									externasTables = _externasTables;
								})
								.catch((error) => {
									reject(error);
								});

							await utils_get_alias(body.scheme, body.entity)
								.then((_aliasTable: string) => {
									aliasTable = _aliasTable;
								})
								.catch((error) => {
									reject(error);
								});

							await ddl_create_view_inner_table(
								body.scheme,
								body.entity,
								body.exclude_column_in_external_table
							)
								.then((_response: boolean) => {
									if (_response) {
										console.log('ddl_create_view_inner_table -> Ok');
									}
								})
								.catch((error: any) => {
									reject(error);
								});

							await ddl_create_crud_modified(
								body.scheme,
								body.entity,
								body.exclude_column_in_external_table
							)
								.then((_response: boolean) => {
									if (_response) {
										console.log('ddl_create_crud_modified -> Ok');
									}
								})
								.catch((error: any) => {
									reject(error);
								});

							generateRestServices(
								basePath,
								body.scheme,
								body.entity,
								columns,
								externasTables
							);

							generateEntityClass(
								basePath,
								body.scheme,
								body.entity,
								columns,
								externasTables
							);

							generateEntityStore(
								basePath,
								body.scheme,
								body.entity,
								columns,
								body.attributeToQuery,
								externasTables,
								aliasTable
							);

							generateEntityController(
								basePath,
								body.scheme,
								body.entity,
								columns,
								body.attributeToQuery,
								externasTables
							).catch((error) => {
								reject(error);
							});

							generateData(basePath, body.scheme, body.entity);
							/**
							 * Generate files
							 */
							generateEntityNetwork(
								basePath,
								body.scheme,
								body.entity,
								body.attributeToQuery,
								externasTables
							);
						})
						.catch((error) => {
							reject(error);
						});

					generateRouter(basePath, body.scheme, body.entity);
					resolve('Entidad Generada!');
				} else {
					reject('La entidad no existe en la base de datos');
				}
			})
			.catch((error) => {
				reject(error);
			});
	});
};

const generateTablesExternal = (entity: string, columnsEntity: []) => {
	return new Promise((resolve, reject) => {
		let externalTables: string[] = [];
		let _externalTables: string[] = [];

		columnsEntity.map(async (item: any) => {
			const column_name: string = item.column_name_;

			if (
				column_name != `id_${entity}` &&
				column_name.substring(0, 3) == 'id_'
			) {
				const table: string = column_name.substring(3, column_name.length);
				externalTables.push(table);
			}
		});

		if (externalTables.length != 0) {
			externalTables.map(async (entity: any, index: number) => {
				await utils_get_schema(entity)
					.then(async (scheme: string) => {
						await utils_get_columns_backend(scheme, entity)
							.then((response) => {
								_externalTables.push(response);
								if (index + 1 == externalTables.length) {
									resolve(_externalTables);
								}
							})
							.catch((error) => {
								reject(error);
							});
					})
					.catch((error) => {
						reject(error);
					});
			});
		} else {
			resolve([]);
		}
	});
};

const generateFolder = (basePath: string, scheme: string, entity: string) => {
	const dir = `${basePath}/app/${scheme}/${entity}`;
	if (!fs.existsSync(dir)) {
		fs.mkdirSync(dir);
	}
};

const generateEntityClass = (
	basePath: string,
	scheme: string,
	entity: string,
	columns: [],
	externasTables: []
) => {
	let queryReadExternalTables: string = '';
	let importsQueryReadExternalTables: string = '';
	const _finalExternal = generateValueEntity(externasTables);

	const _mutateResponse = generateMutateResponse(externasTables, entity);
	let mutateResponse: string = '';
	let deleteTable: string = '';

	_mutateResponse.map((item) => {
		mutateResponse += `${item.nameTable}: ${item.valueTable},`;
		deleteTable += `${item.deleteTable} \n`;
	});

	_finalExternal.map((item: any) => {
		importsQueryReadExternalTables += `view_${entity}_by_${item.nameTable}_query_read,`;
		queryReadExternalTables += `
		by${entityToUpperCase(item.nameTable)}QueryRead() {
			return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
				await view_${entity}_by_${item.nameTable}_query_read(this)
					.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
			entity
		)}[]) => {
						/**
						* Mutate response
						*/
						const _${entityToUpperCaseOutInitial(
							entity
						)}s = this.mutateResponse(${entityToUpperCaseOutInitial(entity)}s);
	
						resolve(_${entityToUpperCaseOutInitial(entity)}s);
					})
					.catch((error: any) => {
						reject(error);
					});
			});
		}
	
`;
	});

	const dir = `${basePath}/app/${scheme}/${entity}/${entity}.class.ts`;
	let imports = ``;
	let attributes = ``;
	let constructor = ``;
	let settersAndGetters = ``;
	let initializer = ``;
	let havedTablesExternal: boolean = false;
	let type_enum: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_udt_name: string = item.column_udt_name_;

		if (column_type === 'USER-DEFINED') {
			type_enum = `
			/**
			 * Type Enum ${column_udt_name}
			 */
			 export type ${column_udt_name} = 'value_replace_1' | 'value_replace_2';
			 
			 export interface ${column_udt_name}_ENUM {
				name_type: string;
				value_type: ${column_udt_name};
			  }
			  
			  export const _${entityToUpperCaseOutInitial(
					column_name
				)}: ${column_udt_name}_ENUM[] = [
				{
				  name_type: 'name_replace',
				  value_type: 'value_replace_1',
				},
				{
				  name_type: 'name_replace',
				  value_type: 'value_replace_2',
				},
			  ];

			  export const validation${entityToUpperCase(column_name)} = (
				attribute: string,
				value: string | ${column_udt_name}
			) => {
				return new Promise<Boolean>((resolve, reject) => {
					const ${entityToUpperCaseOutInitial(
						column_name
					)} = _${entityToUpperCaseOutInitial(column_name)}.find(
						(${entityToUpperCaseOutInitial(column_name)}: ${column_udt_name}_ENUM) =>
						${entityToUpperCaseOutInitial(column_name)}.value_type == value
					);
			
					if (!${entityToUpperCaseOutInitial(column_name)}) {
						reject({
							..._messages[7],
							description: _messages[7].description
								.replace('_nameAttribute', \`\${attribute}\`)
								.replace('_expectedType', '${column_udt_name}'),
						});
					}
				});
			};

			 /**
			  * Type Enum ${column_udt_name}
			  */
			`;
		}

		if (column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`) {
			havedTablesExternal = true;
		}
		imports += `${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? `import { ${entityToUpperCase(
						column_name.substring(3, column_name.length)
				  )} } from '../${column_name.substring(
						3,
						column_name.length
				  )}/${column_name.substring(3, column_name.length)}.class';
				   import { _${entityToUpperCaseOutInitial(
							column_name.substring(3, column_name.length)
						)} } from '../${column_name.substring(
						3,
						column_name.length
				  )}/${column_name.substring(3, column_name.length)}.data';`
				: ''
		}`;

		attributes += `public ${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		}${column_name.substring(0, 3) != `id_` ? '?' : ''}:${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? `${entityToUpperCase(column_name.substring(3, column_name.length))}`
				: `${
						column_type === 'USER-DEFINED'
							? column_udt_name
							: column_type == 'numeric'
							? 'number'
							: column_type == 'boolean'
							? 'boolean'
							: 'string'
				  }`
		};`;
		constructor += `${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		}:${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? `${entityToUpperCase(column_name.substring(3, column_name.length))}`
				: `${
						column_type === 'USER-DEFINED'
							? column_udt_name
							: column_type == 'numeric'
							? 'number'
							: column_type == 'boolean'
							? 'boolean'
							: 'string'
				  }`
		} = ${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? `_${entityToUpperCaseOutInitial(
						column_name.substring(3, column_name.length)
				  )}`
				: `${
						column_type === 'USER-DEFINED'
							? `'value_replace_1'`
							: column_type == 'numeric'
							? 0
							: column_type == 'boolean'
							? false
							: '""'
				  }`
		},`;
		settersAndGetters += `
		set _${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		}(${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		}: ${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? `${entityToUpperCase(column_name.substring(3, column_name.length))}`
				: `${
						column_type === 'USER-DEFINED'
							? column_udt_name
							: column_type == 'numeric'
							? 'number'
							: column_type == 'boolean'
							? 'boolean'
							: 'string'
				  }`
		}) {
			this.${
				column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
					? column_name.substring(3, column_name.length)
					: column_name
			} = ${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		};
		}
		get _${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		}() {
			return this.${
				column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
					? column_name.substring(3, column_name.length)
					: column_name
			}${column_name.substring(0, 3) != `id_` ? '!' : ''};
		}
		`;

		initializer += `this.${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		} = ${
			column_name.substring(0, 3) == `id_` && column_name != `id_${entity}`
				? column_name.substring(3, column_name.length)
				: column_name
		};`;
	});

	attributes = `public id_user_?: number; ${attributes}`;
	constructor = `id_user_: number = 0, ${constructor}`;
	initializer = `this.id_user_ = id_user_; ${initializer}`;

	const classContent = `
${imports}
import {
	dml_${entity}_create,
	dml_${entity}_delete,
	dml_${entity}_update,
	view_${entity}_query_read,
	${importsQueryReadExternalTables}
	view_${entity}_specific_read
} from './${entity}.store';
import { _messages } from '../../../utils/message/message';

export class ${entityToUpperCase(entity)} {
	/** Attributes */
	${attributes}
	/** Constructor */
	constructor(
		${constructor}
	) {
		${initializer}
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}
	
	${settersAndGetters}
	/** Methods */
	create() {
		return new Promise<${entityToUpperCase(entity)}>(async (resolve, reject) => {
			await dml_${entity}_create(this)
				.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
					${
						havedTablesExternal
							? `/**
								* Mutate response
								*/
								const _${entityToUpperCaseOutInitial(
									entity
								)}s = this.mutateResponse(${entityToUpperCaseOutInitial(
									entity
							  )}s);`
							: ''
					}

					resolve(${
						havedTablesExternal
							? `_${entityToUpperCaseOutInitial(entity)}s[0]`
							: `${entityToUpperCaseOutInitial(entity)}s[0] `
					});
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
			await view_${entity}_query_read(this)
				.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		${
			havedTablesExternal
				? `/**
					* Mutate response
					*/
					const _${entityToUpperCaseOutInitial(
						entity
					)}s = this.mutateResponse(${entityToUpperCaseOutInitial(entity)}s);`
				: ''
		}

		resolve(${
			havedTablesExternal
				? `_${entityToUpperCaseOutInitial(entity)}s`
				: `${entityToUpperCaseOutInitial(entity)}s `
		});
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	${queryReadExternalTables}

	specificRead() {
		return new Promise<${entityToUpperCase(entity)}>(async (resolve, reject) => {
			await view_${entity}_specific_read(this)
				.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		${
			havedTablesExternal
				? `/**
					* Mutate response
					*/
					const _${entityToUpperCaseOutInitial(
						entity
					)}s = this.mutateResponse(${entityToUpperCaseOutInitial(entity)}s);`
				: ''
		}

		resolve(${
			havedTablesExternal
				? `_${entityToUpperCaseOutInitial(entity)}s[0]`
				: `${entityToUpperCaseOutInitial(entity)}s[0] `
		});
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<${entityToUpperCase(entity)}>(async (resolve, reject) => {
			await dml_${entity}_update(this)
				.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		${
			havedTablesExternal
				? `/**
					* Mutate response
					*/
					const _${entityToUpperCaseOutInitial(
						entity
					)}s = this.mutateResponse(${entityToUpperCaseOutInitial(entity)}s);`
				: ''
		}

		resolve(${
			havedTablesExternal
				? `_${entityToUpperCaseOutInitial(entity)}s[0]`
				: `${entityToUpperCaseOutInitial(entity)}s[0] `
		});
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_${entity}_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	${
		havedTablesExternal
			? `
			/**
			 * Eliminar ids de entidades externas y formatear la informacion en el esquema correspondiente
			 * @param ${entityToUpperCaseOutInitial(entity)}s
			 * @returns
			 */
			private mutateResponse(${entityToUpperCaseOutInitial(
				entity
			)}s: ${entityToUpperCase(entity)}[]): ${entityToUpperCase(entity)}[] {
				let _${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
					entity
			  )}[] = [];
		
				${entityToUpperCaseOutInitial(entity)}s.map((item: any) => {
					let _${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
					entity
			  )} | any = {
						...item,
						${mutateResponse}
						/**
						 * Generate structure of second level the entity (is important add the ids of entity)
						 * similar the return of read
						 */
					};
					/**
					 * delete ids of principal object level
					 */

					${deleteTable}
		
					_${entityToUpperCaseOutInitial(entity)}s.push(_${entityToUpperCaseOutInitial(
					entity
			  )});
				});
		
				return _${entityToUpperCaseOutInitial(entity)}s;
			}
	`
			: ''
	}
	
}
${type_enum}
`;
	if (!fs.existsSync(dir)) {
		fs.writeFileSync(dir, `${classContent}`);
	}
};

const generateEntityController = (
	basePath: string,
	scheme: string,
	entity: string,
	columns: [],
	attributeToQuery: string,
	externasTables: []
) => {
	return new Promise((resolve, reject) => {
		let queryReadExternalTables: string = '';
		const _finalExternal = generateValueEntity(externasTables);

		_finalExternal.map((item: any) => {
			queryReadExternalTables += `
			else if (url.substring(0, ${
				`/by${entityToUpperCase(item.nameTable)}QueryRead`.length
			}) == '/by${entityToUpperCase(item.nameTable)}QueryRead') {
				const id_${item.nameTable}: any = ${entity}.${item.nameTable};

				if (id_${item.nameTable} >= 1) {
					/** set required attributes for action */
					_${entity}.${item.nameTable} = ${entity}.${item.nameTable};
					_${entity}.${attributeToQuery} = ${entity}.${attributeToQuery};
					await _${entity}
						.by${entityToUpperCase(item.nameTable)}QueryRead()
						.then((_${entity}s: ${entityToUpperCase(entity)}[]) => {
							resolve(_${entity}s);
						})
						.catch((error: any) => {
							reject(error);
						});
				} else {
					reject({
						..._messages[11],
						description: _messages[11].description.replace(
							'name_entity',
							'${item.nameTable}'
						),
					});
				}
			}
	
`;
		});

		const dir = `${basePath}/app/${scheme}/${entity}/${entity}.controller.ts`;
		let instaceAttributes = ``;
		/**
		 * Inicializar la capa de validaciones con la validacion de id_user_
		 */
		let validationCap = `if (url =='/create' || url =='/update') {
			attributeValidate(
				'id_user_',
				${entity}.id_user_,
				'number',
				10
			).catch((err) => {
				validationStatus = true;
				reject(err);
			});
		}
	`;

		let validationCapExternalTables: string = '';
		let importsValidation: string = '';

		columns.map((item: any) => {
			const column_name: string = item.column_name_;
			const column_type: string = item.column_type_;

			instaceAttributes +=
				column_name == `deleted_${entity}`
					? ''
					: column_name.substring(0, 3) == `id_` &&
					  column_name != `id_${entity}`
					? `_${entity}.${column_name.substring(
							3,
							column_name.length
					  )} = ${entity}.${column_name.substring(3, column_name.length)};`
					: `_${entity}.${column_name} = ${entity}.${column_name};`;

			if (column_name == `id_${entity}`) {
				let type = '';
				let length = 0;
				if (column_type == 'character varying' || column_type == 'text') {
					type = 'string';
					length = item.length_character_;
				} else if (column_type == 'numeric') {
					type = 'number';
					length = item.lenght_numeric_;
				} else {
					type = column_type;
				}

				validationCap += `
			if (url =='/update') {
				attributeValidate('id_${entity}', ${entity}.id_${entity}, '${type}' ${
					column_type == 'character varying' ||
					column_type == 'numeric' ||
					column_type == 'text'
						? `, ${length ? length : 9999999999}`
						: ''
				}).catch(
					(err) => {
						validationStatus = true;
						reject(err);
					}
				);
			}
			`;
			} else if (
				column_name != `deleted_${entity}` &&
				column_name.substring(0, 3) != 'id_'
			) {
				let type = '';
				let length = 0;
				if (column_type == 'character varying' || column_type == 'text') {
					type = 'string';
					length = item.length_character_;
				} else if (column_type == 'numeric') {
					type = 'number';
					length = item.lenght_numeric_;
				} else {
					type = column_type;
				}

				validationCap += `
			if (url =='/update') {
				${
					column_type == 'USER-DEFINED'
						? `validation${entityToUpperCase(column_name)}(
							'${column_name}',
							${entity}.${column_name}!
						).catch((err) => {
							validationStatus = true;
							reject(err);
						});`
						: `attributeValidate('${column_name}', ${entity}.${column_name}, '${type}' ${
								column_type == 'character varying' ||
								column_type == 'numeric' ||
								column_type == 'text'
									? `, ${length ? length : 9999999999}`
									: ''
						  }).catch(
					(err) => {
						validationStatus = true;
						reject(err);
					}
				);`
				}}
			`;
				if (column_type == 'USER-DEFINED') {
					importsValidation += `validation${entityToUpperCase(column_name)},`;
				}
			}
		});
		instaceAttributes = `_${entity}.id_user_ = ${entity}.id_user_; ${instaceAttributes}`;

		externasTables.map((itemTable: any[], index: number) => {
			if (itemTable.length > 0) {
				let nameId = itemTable[0].column_name_;

				let nameTable = nameId.substring(3, nameId.length);

				validationCapExternalTables += `
			/**
			 * Validation ${entityToUpperCaseOutInitial(nameTable)}
			 */
			`;
				itemTable.map((item: any) => {
					const column_name: string = item.column_name_;
					const column_type: string = item.column_type_;
					const column_entity: string = column_name.substring(
						3,
						column_name.length
					);

					if (
						column_name.substring(0, 3) == `id_` &&
						column_entity != nameTable
					) {
						let type = '';
						let length = 0;
						if (column_type == 'character varying' || column_type == 'text') {
							type = 'string';
							length = item.length_character_;
						} else if (column_type == 'numeric') {
							type = 'number';
							length = item.lenght_numeric_;
						} else {
							type = column_type;
						}

						validationCapExternalTables += `
				if (url =='/update') {
					attributeValidate('${column_name}', ${entity}.${nameTable}.${column_entity}.${column_name}, '${type}' ${
							column_type == 'character varying' ||
							column_type == 'numeric' ||
							column_type == 'text'
								? `, ${length ? length : 9999999999}`
								: ''
						}).catch(
						(err) => {
							validationStatus = true;
							reject(err);
						}
					);
				}
				`;
					} else if (column_name != `deleted_${nameTable}`) {
						let type = '';
						let length = 0;
						if (column_type == 'character varying' || column_type == 'text') {
							type = 'string';
							length = item.length_character_;
						} else if (column_type == 'numeric') {
							type = 'number';
							length = item.lenght_numeric_;
						} else {
							type = column_type;
						}

						validationCapExternalTables += `
				if (url =='/update') {
					${
						column_type == 'USER-DEFINED'
							? `validation${entityToUpperCase(column_name)}(
						'${column_name}',
						${entity}.${column_name}!
					).catch((err) => {
						validationStatus = true;
						reject(err);
					});`
							: `
							attributeValidate('${column_name}', ${entity}.${nameTable}.${column_name}, '${type}' ${
									column_type == 'character varying' ||
									column_type == 'numeric' ||
									column_type == 'text'
										? `, ${length ? length : 9999999999}`
										: ''
							  }).catch(
					(err) => {
						validationStatus = true;
						reject(err);
					}
				);`
					}}
					`;

						if (column_type == 'USER-DEFINED') {
							importsValidation += `validation${entityToUpperCase(
								column_name
							)},`;
						}
					}
				});
			}
		});

		const classContent = `
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { ${entityToUpperCase(
			entity
		)}, ${importsValidation} } from './${entity}.class';

export const validation = (${entity}: ${entityToUpperCase(
			entity
		)}, url: string, token: string) => {
	return new Promise<${entityToUpperCase(entity)} | ${entityToUpperCase(
			entity
		)}[] | boolean | any>(async (resolve, reject) => {
		/**
		 * Capa de Autentificación con el token
		 */
		let validationStatus: boolean = false;

		if (token) {
			await verifyToken(token)
				.then(async () => {
					/**
					 * Capa de validaciones
					 */
					${validationCap}
					${validationCapExternalTables}
					/**
					 * Continuar solo si no ocurrio errores en la validación
					 */
					if (!validationStatus) {
						/**
						 * Instance the class
						 */
						const _${entity} = new ${entityToUpperCase(entity)}();
						/**
						 * Execute the url depending on the path
						 */
						if (url =='/create') {
							/** set required attributes for action */ 
							_${entity}.id_user_ = ${entity}.id_user_;
							await _${entity}
								.create()
								.then((_${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
			entity
		)}) => {
									resolve(_${entityToUpperCaseOutInitial(entity)});
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 10) =='/queryRead') {
							/** set required attributes for action */ 
							_${entity}.${attributeToQuery} = ${entity}.${attributeToQuery};
							await _${entity}
								.queryRead()
								.then((_${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
			entity
		)}[]) => {
									resolve(_${entityToUpperCaseOutInitial(entity)}s);
								})
								.catch((error: any) => {
									reject(error);
								});
						} ${queryReadExternalTables} else if (url.substring(0, 13) == '/specificRead') {
							const id_${entity}: any = ${entity}.id_${entity};

							if (id_${entity} >= 1) {
							/** set required attributes for action */ 
							_${entity}.id_${entity} = ${entity}.id_${entity};
								await _${entity}
									.specificRead()
									.then((_${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
			entity
		)}) => {
										resolve(_${entityToUpperCaseOutInitial(entity)});
									})
									.catch((error: any) => {
										reject(error);
									});
							} else {
								reject({
									..._messages[11],
									description: _messages[11].description.replace(
										'name_entity',
										'${entity}'
									),
								});
							}

							
						} else if (url =='/update') {
							/** set required attributes for action */ 
							${instaceAttributes}
							await _${entity}
								.update()
								.then((_${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
			entity
		)}) => {
									resolve(_${entityToUpperCaseOutInitial(entity)});
								})
								.catch((error: any) => {
									reject(error);
								});
						} else if (url.substring(0, 7) =='/delete') {
							/** set required attributes for action */ 
							_${entity}.id_user_ = ${entity}.id_user_;
							_${entity}.id_${entity} = ${entity}.id_${entity};
							await _${entity}
								.delete()
								.then((response: boolean) => {
									resolve(response);
								})
								.catch((error: any) => {
									reject(error);
								});
						}
					}
				})
				.catch((error) => {
					reject(error);
				});
		} else {
			reject(_messages[5]);
		}
	});
};

/**
 * Función para validar un campo de acuerdo a los criterios ingresados
 * @param attribute nombre del atributo a validar
 * @param value valor a validar
 * @param type tipo de dato correcto del atributo (string, number, boolean, object)
 * @param _length longitud correcta del atributo
 * @returns true || error
 */
const attributeValidate = (
	attribute: string,
	value: any,
	type: string,
	_length: number = 0
) => {
	return new Promise<Boolean>((resolve, reject) => {
		if (value != undefined || value != null) {
			if (typeof value == \`\${type}\`) {
				if (typeof value == 'string' || typeof value == 'number') {
					if (value.toString().length > _length) {
						reject({
							..._messages[8],
							description: _messages[8].description
								.replace('_nameAttribute', \`\${attribute}\`)
								.replace('_expectedCharacters', \`\${_length}\`),
						});
					} else {
						resolve(true);
					}
				} else {
					resolve(true);
				}
			} else {
				reject({
					..._messages[7],
					description: _messages[7].description
						.replace('_nameAttribute', \`\${attribute}\`)
						.replace('_expectedType', \`\${type}\`),
				});
			}
		} else {
			reject({
				..._messages[6],
				description: _messages[6].description.replace(
					'_nameAttribute',
					\`\${attribute}\`
				),
			});
		}
	});
};
	`;
		if (!fs.existsSync(dir)) {
			fs.writeFileSync(dir, `${classContent}`);
			resolve('');
		}
	});
};

const generateEntityNetwork = (
	basePath: string,
	scheme: string,
	entity: string,
	attributeToQuery: string,
	externasTables: []
) => {
	const dir = `${basePath}/app/${scheme}/${entity}/${entity}.network.ts`;

	let queryReadExternalTables: string = '';
	const _finalExternal = generateValueEntity(externasTables);

	_finalExternal.map((item: any) => {
		queryReadExternalTables += `
		router${entityToUpperCase(entity)}.get('/by${entityToUpperCase(
			item.nameTable
		)}QueryRead/:${
			item.nameTable
		}/:${attributeToQuery}', async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
			entity
		)}[]) => {
				res.status(200).send(${entityToUpperCaseOutInitial(entity)}s);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	});
	
`;
	});

	const classContent = `
	import express from 'express';
import { error, success } from '../../../network/response';
import { validation } from './${entity}.controller';
const router${entityToUpperCase(entity)} = express.Router();
import { ${entityToUpperCase(entity)} } from './${entity}.class';
import { MessageAPI } from '../../../utils/message/message.type';

router${entityToUpperCase(
		entity
	)}.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
			success(res, ${entityToUpperCaseOutInitial(entity)});
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

router${entityToUpperCase(
		entity
	)}.get('/queryRead/:${attributeToQuery}', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
			res.status(200).send(${entityToUpperCaseOutInitial(entity)}s);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

${queryReadExternalTables}

router${entityToUpperCase(
		entity
	)}.get('/specificRead/:id_${entity}', async (req: any, res: any) => {
await validation(req.params, req.url, req.headers.token)
	.then((${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
		res.status(200).send(${entityToUpperCaseOutInitial(entity)});
	})
	.catch((err: MessageAPI | any) => {
		error(res, err);
	});
});

router${entityToUpperCase(
		entity
	)}.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
			success(res, ${entityToUpperCaseOutInitial(entity)});
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

router${entityToUpperCase(
		entity
	)}.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { router${entityToUpperCase(entity)} };
	`;
	if (!fs.existsSync(dir)) {
		fs.writeFileSync(dir, `${classContent}`);
	}
};

const generateEntityStore = (
	basePath: string,
	scheme: string,
	entity: string,
	columns: [],
	attributeToQuery: string,
	externasTables: [],
	aliasTable: string
) => {
	let queryReadExternalTables: string = '';
	const _finalExternal = generateValueEntity(externasTables);

	_finalExternal.map((item: any) => {
		queryReadExternalTables += `
		export const view_${entity}_by_${
			item.nameTable
		}_query_read = (${entity}: ${entityToUpperCase(entity)}) => {
			return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
				const query = \`select * from ${scheme}.view_${entity}_inner_join ${aliasTable}ij\${${entity}.${attributeToQuery} != '*' ? \` where lower(${aliasTable}ij.${attributeToQuery}) LIKE '%\${${entity}.${attributeToQuery}}%' and ${aliasTable}ij.id_${
			item.nameTable
		} = \${${entity}.${item.nameTable}}\` : \` where ${aliasTable}ij.id_${
			item.nameTable
		} = \${${entity}.${item.nameTable}}\`
				} order by ${aliasTable}ij.id_${entity} desc\`;
				
				// console.log(query);
	
				try {
					const response = await clientNASHORPostgreSQL.query(query);
					resolve(response.rows);
				} catch (error: any) {
					if (error.detail == '_database') {
						reject({
							..._messages[3],
							description: error.toString().slice(7),
						});
					} else {
						reject(error.toString());
					}
				}
			});
		};
`;
	});

	const dir = `${basePath}/app/${scheme}/${entity}/${entity}.store.ts`;
	let createParams = ``;
	let updateParams = ``;

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;

		updateParams += `${
			column_name.substring(0, 3) == 'id_' && column_name != `id_${entity}`
				? `			\${${entity}.${column_name.substring(
						3,
						column_name.length
				  )}.${column_name}},\n`
				: `${
						column_type == 'character varying' || column_type == 'USER-DEFINED'
							? `			'\${${entity}.${column_name}}',`
							: `			\${${entity}.${column_name}},`
				  }\n`
		}`;
	});

	createParams = `\${${entity}.id_user_}}`;
	updateParams = `\${${entity}.id_user_},\n${updateParams}`;

	createParams = createParams.substring(0, createParams.length - 1);

	externasTables.map((itemTable: any[], i) => {
		if (itemTable.length > 0) {
			let idTable = itemTable[0].column_name_;
			let nameTable = idTable.substring(3, idTable.length);
			let columnsTable: string = ``;

			itemTable.map((item: any) => {
				const column_name: string = item.column_name_;
				const column_type: string = item.column_type_;

				columnsTable += `${
					column_name != `id_${nameTable}` &&
					column_name != `deleted_${nameTable}`
						? `${
								column_type == 'character varying' ||
								column_type == 'USER-DEFINED'
									? `			'\${${entity}.${nameTable}.${column_name}}',\n`
									: `			\${${entity}.${nameTable}.${column_name}},\n`
						  }`
						: ``
				}`;
			});

			updateParams += columnsTable;
		}
	});

	updateParams = updateParams.substring(0, updateParams.length - 2);

	const classContent = `
	import { clientNASHORPostgreSQL } from '../../../utils/conections';
	import { _messages } from '../../../utils/message/message';
	import { ${entityToUpperCase(entity)} } from './${entity}.class';

	export const dml_${entity}_create = (${entity}: ${entityToUpperCase(
		entity
	)}) => {
		return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
			const query = \`select * from ${scheme}.dml_${entity}_create_modified(${createParams})\`;
			
			// console.log(query);

			try {
				const response = await clientNASHORPostgreSQL.query(query);
				resolve(response.rows);
			} catch (error: any) {
				if (error.detail == '_database') {
					reject({
						..._messages[3],
						description: error.toString().slice(7),
					});
				} else {
					reject(error.toString());
				}
			}
		});
	};

	export const view_${entity}_query_read = (${entity}: ${entityToUpperCase(
		entity
	)}) => {
		return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
			const query = \`select * from ${scheme}.view_${entity}_inner_join ${aliasTable}ij\${${entity}.${attributeToQuery} != '*' ? \` where lower(${aliasTable}ij.${attributeToQuery}) LIKE '%\${${entity}.${attributeToQuery}}%'\` : \`\`
			} order by ${aliasTable}ij.id_${entity} desc\`;
			
			// console.log(query);

			try {
				const response = await clientNASHORPostgreSQL.query(query);
				resolve(response.rows);
			} catch (error: any) {
				if (error.detail == '_database') {
					reject({
						..._messages[3],
						description: error.toString().slice(7),
					});
				} else {
					reject(error.toString());
				}
			}
		});
	};

	${queryReadExternalTables}

	export const view_${entity}_specific_read = (${entity}: ${entityToUpperCase(
		entity
	)}) => {
		return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
			const query = \`select * from ${scheme}.view_${entity}_inner_join ${aliasTable}ij where ${aliasTable}ij.id_${entity} = \${${entity}.id_${entity}}\`;
			
			// console.log(query);

			try {
				const response = await clientNASHORPostgreSQL.query(query);
				resolve(response.rows);
			} catch (error: any) {
				if (error.detail == '_database') {
					reject({
						..._messages[3],
						description: error.toString().slice(7),
					});
				} else {
					reject(error.toString());
				}
			}
		});
	};
	
	export const dml_${entity}_update = (${entity}: ${entityToUpperCase(
		entity
	)}) => {
		return new Promise<${entityToUpperCase(entity)}[]>(async (resolve, reject) => {
			const query = \`select * from ${scheme}.dml_${entity}_update_modified(${updateParams})\`;
	
			// console.log(query);

			try {
				const response = await clientNASHORPostgreSQL.query(query);
				resolve(response.rows);
			} catch (error: any) {
				if (error.detail == '_database') {
					reject({
						..._messages[3],
						description: error.toString().slice(7),
					});
				} else {
					reject(error.toString());
				}
			}
		});
	};
	
	export const dml_${entity}_delete = (${entity}: ${entityToUpperCase(
		entity
	)}) => {
		return new Promise<boolean>(async (resolve, reject) => {
			const query = \`select * from ${scheme}.dml_${entity}_delete${
		externasTables.length != 0 ? '_modified' : ''
	}(\${${entity}.id_user_},\${${entity}.id_${entity}}) as result\`;
			
			// console.log(query);
			
			try {
				const response = await clientNASHORPostgreSQL.query(query);
				resolve(response.rows[0].result);
			} catch (error: any) {
				if (error.detail == '_database') {
					reject({
						..._messages[3],
						description: error.toString().slice(7),
					});
				} else {
					reject(error.toString());
				}
			}
		});
	};
	`;
	if (!fs.existsSync(dir)) {
		fs.writeFileSync(dir, `${classContent}`);
	}
};

const generateRestServicesExternals = (
	basePath: string,
	scheme: string,
	entity: string,
	nameVarUrlBaseApp: string,
	nameVarTokenApp: string,
	_finalExternal: any[]
) => {
	_finalExternal.map((item: any) => {
		const diQueryRead = `${basePath}/app/${scheme}/${entity}/2.${entity}.rest.by${entityToUpperCase(
			item.nameTable
		)}QueryRead.json`;

		let queryRead = `
			{
				"nameFather": "${entity}",
				"name": "by${entityToUpperCase(item.nameTable)}QueryRead",
				"method": "GET",
				"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/by${entityToUpperCase(
			item.nameTable
		)}QueryRead/:id_${item.nameTable}/*",
				"headers": {
					"token": "{{${nameVarTokenApp}}}"
				}
			}
			`;

		if (!fs.existsSync(diQueryRead)) {
			fs.writeFileSync(diQueryRead, `${queryRead}`);
		}
	});
};

const generateRestServices = (
	basePath: string,
	scheme: string,
	entity: string,
	columns: [],
	externasTables: []
) => {
	const dirPost = `${basePath}/app/${scheme}/${entity}/1.${entity}.rest.create.json`;
	const dirRead = `${basePath}/app/${scheme}/${entity}/2.${entity}.rest.queryRead.json`;
	const dirspecificRead = `${basePath}/app/${scheme}/${entity}/2.${entity}.rest.specificRead.json`;
	const dirUpdate = `${basePath}/app/${scheme}/${entity}/3.${entity}.rest.update.json`;
	const dirDelete = `${basePath}/app/${scheme}/${entity}/4.${entity}.rest.delete.json`;
	const nameVarUrlBaseApp = 'urlBaseApiNASHOR';
	const nameVarTokenApp = 'tokenNASHOR';
	/**
	 * Generate
	 */
	let bodyPost = ``;
	let bodyUpdate = ``;
	let bodyDelete = ``;
	const _finalExternal = generateValueEntity(externasTables);

	generateRestServicesExternals(
		basePath,
		scheme,
		entity,
		nameVarUrlBaseApp,
		nameVarTokenApp,
		_finalExternal
	);

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;

		if (column_name.substring(0, 3) == 'id_' && column_name != `id_${entity}`) {
			let table = column_name.substring(3, column_name.length);

			let _bodyTable = _finalExternal.find((item) => item.nameTable == table);

			bodyUpdate += `"${
				column_name != `deleted_${entity}`
					? `${
							column_name.substring(0, 3) == 'id_' &&
							column_name != `id_${entity}`
								? `${table}`
								: `${column_name}`
					  }`
					: ''
			}": ${_bodyTable?.valueTable},`;
		} else if (column_name != `deleted_${entity}`) {
			bodyUpdate += `"${
				column_name != `deleted_${entity}` ? `${column_name}` : ''
			}": ${
				column_type == 'numeric' ? 1 : column_type == 'boolean' ? false : '""'
			},`;
		}
		/**
		 * Delete
		 */
		if (column_name == `id_${entity}`) {
			bodyDelete += `"${column_name}": ${
				column_type == 'numeric' ? 1 : column_type == 'boolean' ? false : '""'
			},`;
		}
	});
	bodyPost = `"id_user_": 1`;
	bodyUpdate = `"id_user_": 1, ${bodyUpdate.substring(
		0,
		bodyUpdate.length - 1
	)}`;
	bodyDelete = `"id_user_": 1, ${bodyDelete.substring(
		0,
		bodyDelete.length - 1
	)}`;

	let postServices = `
	{
		"nameFather": "${entity}",
		"name": "create",
		"method": "POST",
		"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/create",
		"headers": {
			"token": "{{${nameVarTokenApp}}}"
		},
		"body": {${bodyPost}}
	}
	`;

	let getServices = `
	{
		"nameFather": "${entity}",
		"name": "queryRead",
		"method": "GET",
		"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/queryRead/*",
		"headers": {
			"token": "{{${nameVarTokenApp}}}"
		}
	}
	`;

	let getSpecificReadServices = `
	{
		"nameFather": "${entity}",
		"name": "specificRead",
		"method": "GET",
		"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/specificRead/{id_${entity}}",
		"headers": {
			"token": "{{${nameVarTokenApp}}}"
		}
	}
	`;

	let updateServices = `
	{
		"nameFather": "${entity}",
		"name": "update",
		"method": "PATCH",
		"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/update",
		"headers": {
			"token": "{{${nameVarTokenApp}}}"
		},
		"body": {${bodyUpdate}}
	}
	`;

	let deleteServices = `
	{
		"nameFather": "${entity}",
		"name": "delete",
		"method": "DEL",
		"url": "{{${nameVarUrlBaseApp}}}/app/${scheme}/${entity}/delete",
		"headers": {
			"token": "{{${nameVarTokenApp}}}"
		},
		"params": {${bodyDelete}}
	}`;

	if (!fs.existsSync(dirPost)) {
		fs.writeFileSync(dirPost, `${postServices}`);
		fs.writeFileSync(dirRead, `${getServices}`);
		fs.writeFileSync(dirspecificRead, `${getSpecificReadServices}`);
		fs.writeFileSync(dirUpdate, `${updateServices}`);
		fs.writeFileSync(dirDelete, `${deleteServices}`);
	}
};

const generateValueEntity = (externasTables: []) => {
	let finalExternal: ExternasTables[] = [];
	externasTables.map((itemTable: any[]) => {
		if (itemTable.length > 0) {
			let _nameIdTable: string = itemTable[0].column_name_;
			let _valueTable: string = ``;
			let table: ExternasTables = { nameTable: '', valueTable: '' };

			let _nameTable = _nameIdTable.substring(3, _nameIdTable.length);

			table.nameTable = _nameTable;

			itemTable.map((item: any) => {
				const column_name: string = item.column_name_;
				const column_type: string = item.column_type_;

				_valueTable += `${
					column_name != `deleted_${_nameTable}`
						? `${column_name}: ${
								column_name.substring(0, 3) == `id_` &&
								column_name != `${_nameIdTable}`
									? '{}'
									: `${
											column_type == 'numeric'
												? 0
												: column_type == 'boolean'
												? false
												: '""'
									  }`
						  },`
						: ''
				}`;
			});

			table.valueTable = `{${_valueTable.substring(
				0,
				_valueTable.length - 1
			)}}`;
			finalExternal.push(table);
		}
	});

	return finalExternal;
};

const generateMutateResponse = (externasTables: [], entity: string) => {
	let finalExternal: ExternasTables[] = [];
	externasTables.map((itemTable: any[]) => {
		if (itemTable.length > 0) {
			let _nameIdTable: string = itemTable[0].column_name_;
			let _valueTable: string = ``;
			let _deleteTable: string = '';
			let table: ExternasTables = { nameTable: '', valueTable: '' };

			let _nameTable = _nameIdTable.substring(3, _nameIdTable.length);

			table.nameTable = _nameTable;

			itemTable.map((item: any) => {
				const column_name: string = item.column_name_;

				_valueTable += `${
					column_name != `deleted_${_nameTable}`
						? `${
								column_name != `id_${_nameTable}` &&
								column_name.substring(0, 3) == 'id_'
									? `${column_name.substring(
											3,
											column_name.length
									  )}: {${column_name}:item.${column_name}},`
									: `${column_name}: item.${column_name},`
						  }`
						: ''
				}`;

				_deleteTable += `${
					column_name != `deleted_${_nameTable}`
						? `delete _${entityToUpperCaseOutInitial(entity)}.${column_name};`
						: ''
				}`;
			});

			table.valueTable = `{${_valueTable.substring(
				0,
				_valueTable.length - 1
			)}}`;

			table.deleteTable = _deleteTable;

			finalExternal.push(table);
		}
	});

	return finalExternal;
};

interface ExternasTables {
	nameTable: string;
	valueTable: any;
	deleteTable?: string;
}

const generateRouter = (basePath: string, scheme: string, entity: string) => {
	const dir = `${basePath}/app/${scheme}/${entity}/5.${entity}.routes.ts`;
	const classContent = `
	//import { router${entityToUpperCase(
		entity
	)} } from '../app/${scheme}/${entity}/${entity}.network';
	//app.use('/app/${scheme}/${entity}', router${entityToUpperCase(entity)});
	`;
	if (!fs.existsSync(dir)) {
		fs.writeFileSync(dir, `${classContent}`);
	}
};

const generateData = (basePath: string, scheme: string, entity: string) => {
	const dir = `${basePath}/app/${scheme}/${entity}/${entity}.data.ts`;

	const dataContent = `
	import { ${entityToUpperCase(entity)} } from './${entity}.class';
	export const _${entityToUpperCaseOutInitial(entity)} = new ${entityToUpperCase(
		entity
	)}();
	`;
	if (!fs.existsSync(dir)) {
		fs.writeFileSync(dir, `${dataContent}`);
	}
};
