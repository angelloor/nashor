import fs from 'fs';
import path from 'path';
import {
	utils_get_columns_backend,
	utils_get_schema,
	utils_table_exists
} from './dev.store';
import { AttributeList, BodyFrontendGenerate } from './utils/dev.types';
import {
	entityReplaceUnderscore,
	entityToLowerCase,
	entityToUpperCase,
	entityToUpperCaseOutInitial
} from './utils/dev.utils';

const entityFrontendGenerate = (body: BodyFrontendGenerate) => {
	return new Promise<string>((resolve, reject) => {
		utils_table_exists(body.scheme, body.entity)
			.then(async (count) => {
				if (count == 1) {
					const basePath = path.join(__dirname, body.pathToCreate);
					let columns: [];
					let externasTables: [];
					/**
					 * Generate folder for the entity
					 */
					generateFolder(basePath, body.entity);
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

							generateType(basePath, body.entity, columns);
							generateData(basePath, body.entity, columns);
							generateService(
								basePath,
								body.scheme,
								body.entity,
								columns,
								body.attributeList,
								externasTables
							);
							generateResolver(basePath, body.entity);
							generateHtml(basePath, body.entity);
							generateComponent(basePath, body.entity);
							/**
							 * Child components
							 */
							generateListHtml(
								basePath,
								body.entity,
								body.nameVisibility,
								body.attributeList,
								columns
							);
							generateListComponent(
								basePath,
								body.entity,
								body.nameVisibility,
								columns
							);
							generateDetailsHtml(basePath, body.entity, columns);
							generateDetailsComponent(
								basePath,
								body.entity,
								body.nameVisibility,
								columns
							);
							/**
							 *
							 */
							generateGuard(basePath, body.entity);
							generateRouting(basePath, body.entity);
							generateModule(basePath, body.entity);

							generateModalSelect(basePath, body.entity, body.nameVisibility);
						})
						.catch((error) => {
							reject(error);
						});
					resolve('ok');
				} else {
					reject('La entidad no existe en la base de datos');
				}
			})
			.catch((error) => {
				reject(error);
			});
	});
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

interface ExternasTables {
	nameTable: string;
	valueTable: any;
}

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

const generateFolder = (basePath: string, entity: string) => {
	if (!fs.existsSync(basePath)) {
		fs.mkdirSync(`${basePath}`);
	}

	if (
		fs.existsSync(basePath) &&
		!fs.existsSync(`${basePath}details`) &&
		!fs.existsSync(`${basePath}list`)
	) {
		fs.mkdirSync(`${basePath}details`);
		fs.mkdirSync(`${basePath}list`);
	}

	if (
		!fs.existsSync(`${basePath}modal-select-${entityReplaceUnderscore(entity)}`)
	) {
		fs.mkdirSync(`${basePath}modal-select-${entityReplaceUnderscore(entity)}`);
	}
};

const generateHtml = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.component.html`;

	const contentHtml: string = `
	<router-outlet></router-outlet>
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentHtml);
	}
};

const generateComponent = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.component.ts`;

	const contentComponent: string = `
	import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-${entityReplaceUnderscore(entity)}',
  templateUrl: './${entityReplaceUnderscore(entity)}.component.html',
})
export class ${entityToUpperCase(entity)}Component implements OnInit {
  constructor() {}

  ngOnInit(): void {}
}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentComponent);
	}
};

const generateType = (basePath: string, entity: string, columns: []) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.types.ts`;
	let attributes: string = '';
	let type_enum: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_udt_name: string = item.column_udt_name_;
		const column_id: string = column_name.substring(0, 3);
		const column_entity: string = column_name.substring(3, column_name.length);

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
			 /**
			  * Type Enum ${column_udt_name}
			  */
			`;
		}

		attributes += `${
			column_name == `id_${entity}`
				? `id_${entity}`
				: column_id == `id_`
				? `${column_entity}`
				: column_name
		}:${
			column_type === 'USER-DEFINED'
				? `${column_udt_name}`
				: column_name == `id_${entity}`
				? 'string'
				: column_id == `id_`
				? `${entityToUpperCase(column_entity)}`
				: column_type == 'numeric'
				? 'number'
				: column_type == 'boolean'
				? 'boolean'
				: 'string'
		};`;
	});

	const contentType: string = `export interface ${entityToUpperCase(entity)} {
		${attributes}
	  }
	  ${type_enum}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentType);
	}
};

const generateData = (basePath: string, entity: string, columns: []) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.data.ts`;
	let attributes: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_id: string = column_name.substring(0, 3);
		const column_entity: string = column_name.substring(3, column_name.length);

		attributes += `${
			column_name == `id_${entity}`
				? `id_${entity}`
				: column_id == `id_`
				? `${column_entity}`
				: column_name
		}:${
			column_type === 'USER-DEFINED'
				? `'value_replace_1'`
				: column_name == `id_${entity}`
				? `' '`
				: column_id == `id_`
				? `${entityToUpperCaseOutInitial(column_entity)}`
				: column_type == 'numeric'
				? 1
				: column_type == 'boolean'
				? false
				: `' '`
		},`;
	});

	const contentData: string = `import { ${entityToUpperCase(
		entity
	)} } from './${entityReplaceUnderscore(entity)}.types';
	
	export const ${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[] = [];
	export const ${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)} = {
	  ${attributes}
	};
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentData);
	}
};

const generateService = (
	basePath: string,
	scheme: string,
	entity: string,
	columns: [],
	attributeList: AttributeList,
	externasTables: []
) => {
	let queryReadExternalTables: string = '';
	const _finalExternal = generateValueEntity(externasTables);

	_finalExternal.map((item: any) => {
		queryReadExternalTables += `/**
   * by${entityToUpperCase(item.nameTable)}QueryRead
   * @param id_${item.nameTable}
   * @param query
   */
  by${entityToUpperCase(item.nameTable)}QueryRead(id_${
			item.nameTable
		}: string, query: string): Observable<${entityToUpperCase(entity)}[]> {
    return this._httpClient
      .get<${entityToUpperCase(entity)}[]>(this._url + \`/by${entityToUpperCase(
			item.nameTable
		)}QueryRead/\${id_${item.nameTable}}/\${query ? query : '*'}\`)
      .pipe(
        tap((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
			entity
		)}[]) => {
			if (${entityToUpperCaseOutInitial(entity)}s) {
				this._${entityToUpperCaseOutInitial(
					entity
				)}s.next(${entityToUpperCaseOutInitial(entity)}s);
			  } else {
				this._${entityToUpperCaseOutInitial(entity)}s.next([]);
			  }
        })
      );
  }`;
	});

	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.service.ts`;

	let attributesCreate: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;

		attributesCreate += `${column_name}:${
			column_name == `id_${entity}`
				? "''"
				: column_type == 'numeric'
				? '1'
				: column_type == 'boolean'
				? 'false'
				: column_type == 'character varying' &&
				  column_name == attributeList.first
				? "'Nuevo registro'"
				: "''"
		},`;
	});

	const contentService: string = `
	import { HttpClient, HttpHeaders } from '@angular/common/http';
	import { Injectable } from '@angular/core';
	import {
	  BehaviorSubject,
	  catchError,
	  filter,
	  map,
	  Observable,
	  of,
	  switchMap,
	  take,
	  tap,
	  throwError,
	} from 'rxjs';
	import { environment } from 'environments/environment';
	import { ${entityToUpperCaseOutInitial(entity)}, ${entityToUpperCaseOutInitial(
		entity
	)}s } from './${entityReplaceUnderscore(entity)}.data';
	import { ${entityToUpperCase(entity)} } from './${entityReplaceUnderscore(
		entity
	)}.types';
	
	@Injectable({
		providedIn: 'root',
	  })
	  
	  export class ${entityToUpperCase(entity)}Service {
		private _url: string;
		private _headers: HttpHeaders = new HttpHeaders({
		  'Content-Type': 'application/json',
		});
	  
		private _${entityToUpperCaseOutInitial(
			entity
		)}: BehaviorSubject<${entityToUpperCase(entity)}> = new BehaviorSubject(
			${entityToUpperCaseOutInitial(entity)}
		);
		private _${entityToUpperCaseOutInitial(
			entity
		)}s: BehaviorSubject<${entityToUpperCase(entity)}[]> = new BehaviorSubject(
			${entityToUpperCaseOutInitial(entity)}s
		);
	  
		constructor(private _httpClient: HttpClient) {
		  this._url = environment.urlBackend + '/app/${scheme}/${entity}';
		}
		/**
		 * Getter
		 */
		get ${entityToUpperCaseOutInitial(entity)}$(): Observable<${entityToUpperCase(
		entity
	)}> {
		  return this._${entityToUpperCaseOutInitial(entity)}.asObservable();
		}
		/**
		 * Getter for _${entityToUpperCaseOutInitial(entity)}s
		 */
		get ${entityToUpperCaseOutInitial(entity)}s$(): Observable<${entityToUpperCase(
		entity
	)}[]> {
		  return this._${entityToUpperCaseOutInitial(entity)}s.asObservable();
		}
		/**
   * create
   */
  create(id_user_: string): Observable<any> {
    return this._${entityToUpperCaseOutInitial(entity)}s.pipe(
      take(1),
      switchMap((${entityToUpperCaseOutInitial(entity)}s) =>
        this._httpClient
          .post(this._url + '/create', {
			id_user_: parseInt(id_user_),
		  }, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
				/**
				 * check the response body to match with the type
				 */
				const _${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)} = response.body;
				console.log(_${entityToUpperCaseOutInitial(entity)});
				/**
				 * Update the ${entityToUpperCaseOutInitial(entity)} in the store
				 */
              this._${entityToUpperCaseOutInitial(
								entity
							)}s.next([_${entityToUpperCaseOutInitial(
		entity
	)}, ...${entityToUpperCaseOutInitial(entity)}s]);

              return of(_${entityToUpperCaseOutInitial(entity)});
            })
          )
      )
    );
  }
  /**
   * queryRead
   * @param query
   */
   queryRead(query: string): Observable<${entityToUpperCase(entity)}[]> {
    return this._httpClient
      .get<${entityToUpperCase(entity)}[]>(
        this._url + \`/queryRead/\${query ? query : '*'}\`
      )
      .pipe(
        tap((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		if (${entityToUpperCaseOutInitial(entity)}s) {
			this._${entityToUpperCaseOutInitial(
				entity
			)}s.next(${entityToUpperCaseOutInitial(entity)}s);
		  } else {
			this._${entityToUpperCaseOutInitial(entity)}s.next([]);
		  }
        })
      );
  }
  ${queryReadExternalTables}
  /**
   * specificRead
   * @param id_${entityToUpperCaseOutInitial(entity)}
   */
   specificRead(id_${entityToUpperCaseOutInitial(
			entity
		)}: string): Observable<${entityToUpperCase(entity)}> {
    return this._httpClient
      .get<${entityToUpperCase(entity)}>(
        this._url + \`/specificRead/\${id_${entityToUpperCaseOutInitial(
					entity
				)}}\`
      )
      .pipe(
        tap((${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
			this._${entityToUpperCaseOutInitial(entity)}.next(${entityToUpperCaseOutInitial(
		entity
	)});
			return ${entityToUpperCaseOutInitial(entity)}s;
        })
      );
  }
  /**
   * specificReadInLocal
   */
   specificReadInLocal(id_${entityToUpperCaseOutInitial(
			entity
		)}: string): Observable<${entityToUpperCase(entity)}> {
    return this._${entityToUpperCaseOutInitial(entity)}s.pipe(
      take(1),
      map((${entityToUpperCaseOutInitial(entity)}s) => {
		/**
		 * Find
		 */
        const ${entityToUpperCaseOutInitial(entity)} =
          ${entityToUpperCaseOutInitial(
						entity
					)}s.find((item) => item.id_${entity} == id_${entityToUpperCaseOutInitial(
		entity
	)}) || null;
					/**
					 * Update
					 */
        this._${entityToUpperCaseOutInitial(
					entity
				)}.next(${entityToUpperCaseOutInitial(entity)}!);
				/**
				 * Return
				 */
        return ${entityToUpperCaseOutInitial(entity)};
      }),
      switchMap((${entityToUpperCaseOutInitial(entity)}) => {
        if (!${entityToUpperCaseOutInitial(entity)}) {
          return throwError(
            () => 'No se encontro el elemento con el id ' + id_${entityToUpperCaseOutInitial(
							entity
						)} + '!'
          );
        }
        return of(${entityToUpperCaseOutInitial(entity)});
      })
    );
  }
  /**
   * update
   * @param ${entityToUpperCaseOutInitial(entity)}
   */
  update(${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}): Observable<any> {
    return this.${entityToUpperCaseOutInitial(entity)}s$.pipe(
      take(1),
      switchMap((${entityToUpperCaseOutInitial(entity)}s) =>
        this._httpClient
          .patch(this._url + '/update',${entityToUpperCaseOutInitial(entity)}, {
            headers: this._headers,
          })
          .pipe(
            switchMap((response: any) => {
				/**
				 * check the response body to match with the type
				 */
				const _${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)} = response.body;
				console.log(_${entityToUpperCaseOutInitial(entity)});
				/**
				 * Find the index of the updated ${entityToUpperCaseOutInitial(entity)}
				 */
              const index = ${entityToUpperCaseOutInitial(entity)}s.findIndex(
                (item) => item.id_${entity} == ${entityToUpperCaseOutInitial(
		entity
	)}.id_${entity}
              );
			  console.log(index);
			  /**
				 * Update the ${entityToUpperCaseOutInitial(entity)}
				 */
              ${entityToUpperCaseOutInitial(
								entity
							)}s[index] = _${entityToUpperCaseOutInitial(entity)};
				/**
				 * Update the ${entityToUpperCaseOutInitial(entity)}s
				 */
              this._${entityToUpperCaseOutInitial(
								entity
							)}s.next(${entityToUpperCaseOutInitial(entity)}s);

							/**
							 * Update the ${entityToUpperCaseOutInitial(entity)}
							 */
						  this._${entityToUpperCaseOutInitial(
								entity
							)}.next(_${entityToUpperCaseOutInitial(entity)});

				return of(_${entityToUpperCaseOutInitial(entity)})							
            })
          )
      )
    );
  }
  /**
   * delete
   * @param id_user_
   * @param id_${entity}
   */
  delete(
    id_user_: string,
    id_${entity}: string
  ): Observable<any> {
    return this.${entityToUpperCaseOutInitial(entity)}s$.pipe(
      take(1),
      switchMap((${entityToUpperCaseOutInitial(entity)}s) =>
        this._httpClient
          .delete(this._url + \`/delete\`, {
            params: { id_user_, id_${entity} },
          })
          .pipe(
            switchMap((response: any) => {
				if (response && response.body) {
					/**
					 * Find the index of the updated ${entityToUpperCaseOutInitial(entity)}
					 */
						const index = ${entityToUpperCaseOutInitial(entity)}s.findIndex(
							(item) => item.id_${entity} == id_${entity}
						);
						console.log(index);
						/**
						 * Delete the object of array
						 */
						${entityToUpperCaseOutInitial(entity)}s.splice(index, 1);
						/**
						 * Update the ${entityToUpperCaseOutInitial(entity)}s
						 */
						this._${entityToUpperCaseOutInitial(
							entity
						)}s.next(${entityToUpperCaseOutInitial(entity)}s);
						return of(response.body);
					} else {
					  return of(false);
					}
            })
          )
      )
    );
  }
}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentService);
	}
};

const generateResolver = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.resolvers.ts`;

	const contentResolver: string = `
	import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  Resolve,
  Router,
  RouterStateSnapshot,
} from '@angular/router';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { ${entityToUpperCase(
		entity
	)}Service } from './${entityReplaceUnderscore(entity)}.service';
import { ${entityToUpperCase(entity)} } from './${entityReplaceUnderscore(
		entity
	)}.types';

@Injectable({
  providedIn: 'root',
})
export class ${entityToUpperCase(entity)}Resolver implements Resolve<any> {
  /**
   * Constructor
   */
  constructor(
    private _${entityToUpperCaseOutInitial(entity)}Service: ${entityToUpperCase(
		entity
	)}Service,
    private _router: Router
  ) {}

   /** ----------------------------------------------------------------------------------------------------- */
   /** @ Public methods
   /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Resolver
   * @param route
   * @param state
   */
  resolve(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<${entityToUpperCase(entity)}> {
    return this._${entityToUpperCaseOutInitial(entity)}Service
      .specificReadInLocal(route.paramMap.get('id_${entity}')!)
      .pipe(
		/**
		 * Error here means the requested is not available
		 */
        catchError((error) => {
			/**
				 * Log the error
				 */
          // console.error(error);
		  /**
		   * Get the parent url
		   */
          const parentUrl = state.url.split('/').slice(0, -1).join('/');
		  /**
				 * Navigate to there
				 */
          this._router.navigateByUrl(parentUrl);
		  /**
		   * Throw an error
		   */
          return throwError(() => error);
        })
      );
  }
}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentResolver);
	}
};

const generateListHtml = (
	basePath: string,
	entity: string,
	nameVisibility: string,
	attributeList: AttributeList,
	columns: []
) => {
	const pathToCreate: string = `${basePath}list/list.component.html`;

	const contentListHtml: string = `
	<div class="absolute inset-0 flex flex-col min-w-0 overflow-hidden">

    <mat-drawer-container class="flex-auto h-full bg-card dark:bg-transparent" (backdropClick)="onBackdropClicked()">

        <!-- Drawer -->
        <mat-drawer class="w-full md:w-160 dark:bg-gray-900" [mode]="drawerMode" [opened]="false" [position]="'end'"
            [disableClose]="true" #matDrawer>
            <router-outlet></router-outlet>
        </mat-drawer>

        <mat-drawer-content class="flex flex-col">

            <!-- Main -->
            <div class="flex-auto">

                <!-- Header -->
                <div class="flex flex-col sm:flex-row md:flex-col flex-auto justify-between py-8 px-6 md:px-8 border-b">

                    <!-- Title -->
                    <div>
                        <div class="text-4xl font-extrabold tracking-tight leading-none">${nameVisibility}</div>
                        <div class="ml-0.5 font-medium text-secondary">
                            <ng-container *ngIf="count > 0">
                                {{count}}
                            </ng-container>
                            {{count | i18nPlural: {
                            '=0' : 'No hay ${nameVisibility}',
                            '=1' : '${nameVisibility}',
                            'other': '${nameVisibility}'
                            } }}
                        </div>
                    </div>

                    <!-- Main actions -->
                    <div class="flex items-center mt-4">
                        <!-- Search -->
                        <div class="flex-auto">
                            <mat-form-field class="angel-mat-dense angel-mat-no-subscript w-full min-w-50">
                                <mat-icon class="icon-size-5" matPrefix [svgIcon]="'heroicons_solid:search'"></mat-icon>
                                <input matInput [formControl]="searchInputControl" [autocomplete]="'off'"
                                    [placeholder]="'Buscar por ...'">
                            </mat-form-field>
                        </div>
                        <!-- Add button -->
                        <button class="ml-4" mat-flat-button [color]="'primary'" (click)="create${entityToUpperCase(
													entity
												)}()">
                            <mat-icon [svgIcon]="'heroicons_outline:plus'"></mat-icon>
                            <span class="ml-2 mr-1">Añadir</span>
                        </button>
                    </div>
                </div>
                <!-- list -->
                <div class="relative">
                    <ng-container *ngIf="${entityToUpperCaseOutInitial(
											entity
										)}s$ | async as ${entityToUpperCaseOutInitial(entity)}s">
                        <ng-container *ngIf="${entityToUpperCaseOutInitial(
													entity
												)}s.length; else noResults">
                            <ng-container *ngFor="let ${entityToUpperCaseOutInitial(
															entity
														)} of ${entityToUpperCaseOutInitial(
		entity
	)}s; let i = index; trackBy: trackByFn">
                                <!-- Entity -->
                                <div class="z-20 flex items-center px-6 py-4 md:px-8 cursor-pointer hover:bg-hover border-b"
                                    [ngClass]="{'bg-primary-50 dark:bg-hover': selected${entityToUpperCase(
																			entity
																		)} && selected${entityToUpperCase(
		entity
	)}.id_${entity} === ${entityToUpperCaseOutInitial(entity)}.id_${entity}}"
									[routerLink]="['./', ${entityToUpperCaseOutInitial(entity)}.id_${entity}]">
                                    <div
                                        class="flex flex-0 items-center justify-center w-10 h-10 rounded-full overflow-hidden">
                                        <ng-container *ngIf="true">
                                            <div
                                                class="flex items-center justify-center w-full h-full rounded-full text-lg uppercase bg-gray-200 text-gray-600 dark:bg-gray-700 dark:text-gray-200">
                                                {{${entityToUpperCaseOutInitial(
																									entity
																								)}.${
		attributeList.first
	}.charAt(0)}}
                                            </div>
                                        </ng-container>
                                    </div>
                                    <div class="min-w-0 ml-4">
                                        <div class="font-medium leading-5 truncate">{{${entityToUpperCaseOutInitial(
																					entity
																				)}.${attributeList.first}}}
                                        </div>
                                        <div class="leading-5 truncate text-secondary">
                                            {{${entityToUpperCaseOutInitial(
																							entity
																						)}.${attributeList.second}}}</div>
                                    </div>
                                </div>
                            </ng-container>
                        </ng-container>
                    </ng-container>

                    <!-- No Results -->
                    <ng-template #noResults>
                        <div class="p-8 sm:p-16 border-t text-4xl font-semibold tracking-tight text-center">¡No hay
                            resultados!</div>
                    </ng-template>

                </div>

            </div>

        </mat-drawer-content>

    </mat-drawer-container>

</div>
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentListHtml);
	}
};

const generateListComponent = (
	basePath: string,
	entity: string,
	nameVisibility: string,
	columns: []
) => {
	const pathToCreate: string = `${basePath}list/list.component.ts`;
	let type_enum: string = '';
	let function_enum: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_udt_name: string = item.column_udt_name_;
		const column_entity: string = column_name.substring(3, column_name.length);

		if (column_type === 'USER-DEFINED') {
			type_enum += `
			/**
			 * Type Enum ${column_udt_name}
			 */
			 ${entityToUpperCaseOutInitial(
					column_name
				)}: ${column_udt_name}_ENUM[] = _${entityToUpperCaseOutInitial(
				column_name
			)};
			 /**
			  * Type Enum ${column_udt_name}
			  */
			`;

			function_enum += `/**
			 * getType${entityToUpperCase(entity)}Enum
			 */
			getType${entityToUpperCase(
				entity
			)}Enum(${column_name}: ${column_udt_name}): ${column_udt_name}_ENUM {
			  return this.${entityToUpperCaseOutInitial(column_name)}.find(
				(${column_entity}) => ${column_entity}.value_type == ${column_name}
			  )!;
			}
			`;
		}
	});

	const contentListComponent: string = `
	import { DOCUMENT } from '@angular/common';
import {
  ChangeDetectorRef,
  Component,
  Inject,
  OnInit,
  ViewChild,
} from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatDrawer } from '@angular/material/sidenav';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { fromEvent, merge, Observable, Subject, timer } from 'rxjs';
import {
  filter,
  finalize,
  switchMap,
  takeUntil,
  takeWhile,
  tap,
} from 'rxjs/operators';
import { AngelMediaWatcherService } from '@angel/services/media-watcher';
import { MessageAPI, AppInitialData } from 'app/core/app/app.type';
import { AuthService } from 'app/core/auth/auth.service';
import { LayoutService } from 'app/layout/layout.service';
import { ActionAngelConfirmation, AngelConfirmationService} from '@angel/services/confirmation';
import { NotificationService } from 'app/shared/notification/notification.service';
import { ${entityToUpperCase(
		entity
	)}Service } from '../${entityReplaceUnderscore(entity)}.service';
import { ${entityToUpperCase(entity)} } from '../${entityReplaceUnderscore(
		entity
	)}.types';

@Component({
  selector: '${entityReplaceUnderscore(entity)}-list',
  templateUrl: './list.component.html',
})
export class ${entityToUpperCase(entity)}ListComponent implements OnInit {
  @ViewChild('matDrawer', { static: true }) matDrawer!: MatDrawer;
  count: number = 0;
  ${entityToUpperCaseOutInitial(entity)}s$!: Observable<${entityToUpperCase(
		entity
	)}[]>;

  openMatDrawer: boolean = false;
  
  private data!: AppInitialData;
  /**
   * Shortcut
   */
  private keyControl: boolean = false;
  private keyShift: boolean = false;
  private keyAlt: boolean = false;
  private timeToWaitKey: number = 500; //ms
  /**
   * Shortcut
   */

  ${type_enum}
  
  drawerMode!: 'side' | 'over';
  searchInputControl: FormControl = new FormControl();
  selected${entityToUpperCase(entity)}!: ${entityToUpperCase(entity)};

  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _activatedRoute: ActivatedRoute,
    private _changeDetectorRef: ChangeDetectorRef,
    @Inject(DOCUMENT) private _document: any,
    private _router: Router,
    private _angelMediaWatcherService: AngelMediaWatcherService,
    private _${entityToUpperCaseOutInitial(entity)}Service: ${entityToUpperCase(
		entity
	)}Service,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
	private _layoutService: LayoutService,
    private _authService: AuthService
  ) {}

  ngOnInit(): void {
	/**
     * checkSession
     */
    this._authService
      .checkSession()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe();
    /**
     * checkSession
     */
	/**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
	/**
	 * Subscribe to user changes of state
	 */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
    });
	/**
	 * Get the ${entityToUpperCaseOutInitial(entity)}s 
	 */
    this.${entityToUpperCaseOutInitial(
			entity
		)}s$ = this._${entityToUpperCaseOutInitial(
		entity
	)}Service.${entityToUpperCaseOutInitial(entity)}s$;
	/**
	 *  queryRead *
	 */
    this._${entityToUpperCaseOutInitial(entity)}Service
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		/**
		* Update the counts
		*/
        this.count = ${entityToUpperCaseOutInitial(entity)}s.length;
		/**
		 * Mark for check
		 */
        this._changeDetectorRef.markForCheck();
      });
	  /**
	 *  Count Subscribe
	 */
    this._${entityToUpperCaseOutInitial(entity)}Service
      .${entityToUpperCaseOutInitial(entity)}s$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
		/**
		* Update the counts
		*/
        this.count = ${entityToUpperCaseOutInitial(entity)}s.length;
		/**
		 * Mark for check
		 */
        this._changeDetectorRef.markForCheck();
      });
	  /**
	   * Subscribe to search input field value changes  
	   */
    this.searchInputControl.valueChanges
      .pipe(
        takeUntil(this._unsubscribeAll),
        switchMap((query) => {
			/**
			 * Search
			 */
          return this._${entityToUpperCaseOutInitial(entity)}Service.queryRead(
            query.toLowerCase()
          );
        })
      )
      .subscribe();
	  /**
	   * Subscribe to media changes 
	   */
    this._angelMediaWatcherService.onMediaChange$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe(({ matchingAliases }) => {
		/**
		 * Set the drawerMode if the given breakpoint is active
		 */
        if (matchingAliases.includes('lg')) {
          this.drawerMode = 'side';
        } else {
          this.drawerMode = 'over';
        }
		/**
		 * Mark for check
		 */
        this._changeDetectorRef.markForCheck();
      });
	  /**
	   * Subscribe to MatDrawer opened change
	   */
    this.matDrawer.openedChange
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((opened) => {
        this.openMatDrawer = opened;
        if (!opened) {
			/**
			 * Remove the selected when drawer closed
			 */
          this.selected${entityToUpperCase(entity)} = null!;
		  /**
		   * Mark for check
		   */
          this._changeDetectorRef.markForCheck();
        }
      });
	  /**
	   * Shortcuts
	   */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Control')
      ),
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Shift')
      ),
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Alt')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
		/**
         * Shortcut create
         */
        if (keyUpOrKeyDown.key == 'Control') {
          this.keyControl = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }
        if (keyUpOrKeyDown.key == 'Shift') {
          this.keyShift = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }
        if (keyUpOrKeyDown.key == 'Alt') {
          this.keyAlt = true;

          timer(100, 100)
            .pipe(
              finalize(() => {
                this.resetKeyboard();
              }),
              takeWhile(() => this.timeToWaitKey > 0),
              takeUntil(this._unsubscribeAll),
              tap(() => this.timeToWaitKey--)
            )
            .subscribe();
        }

        if (
          !this.isOpenModal &&
          this.keyControl &&
          this.keyShift &&
          this.keyAlt
        ) {
          this.create${entityToUpperCase(entity)}();
        }
      });
	  /**
       * Shortcuts
       */
  }
  /**
   * resetKeyboard
   */
  private resetKeyboard() {
    this.keyControl = false;
    this.keyShift = false;
    this.keyAlt = false;
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
	/**
	 * Unsubscribe from all subscriptions
	 */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }

   /** ----------------------------------------------------------------------------------------------------- */
   /** @ Public methods
   /** ----------------------------------------------------------------------------------------------------- */

  /**
   * Go to ${entity}
   * @param id_${entity}
   */
  goToEntity(id_${entity}: string): void {
	/**
	 * Get the current activated route
	 */
    let route = this._activatedRoute;
    while (route.firstChild) {
      route = route.firstChild;
    }
	/**
	 * Go to ${entity}
	 */
    this._router.navigate([this.openMatDrawer ? '../' : './', id_${entity}], { relativeTo: route });
	/**
	 * Mark for check
	 */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * On backdrop clicked
   */
  onBackdropClicked(): void {
	/**
	 * Get the current activated route
	 */
    let route = this._activatedRoute;
    while (route.firstChild) {
      route = route.firstChild;
    }
	/**
			 * Go to the parent route
			 */
    this._router.navigate(['../'], { relativeTo: route });
	/**
	 * Mark for check
	 */
    this._changeDetectorRef.markForCheck();
  }
  /**
   * create${entityToUpperCase(entity)}
   */
  create${entityToUpperCase(entity)}(): void {
    this._angelConfirmationService
      .open({
		title: 'Añadir ${entityToLowerCase(nameVisibility)}',
        message: '¿Estás seguro de que deseas añadir una nueva ${entityToLowerCase(
					nameVisibility
				)}? ¡Esta acción no se puede deshacer!',
		})
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
		  /**
			 * Create the ${entity}
			 */
          this._${entityToUpperCaseOutInitial(entity)}Service
            .create(id_user_)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
				next: (_${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
				  console.log(_${entityToUpperCaseOutInitial(entity)});
				  if (_${entityToUpperCaseOutInitial(entity)}) {
					this._notificationService.success(
					  '${nameVisibility} agregada correctamente'
					);
					/**
			 * Go to new ${entity}
			 */
					this.goToEntity(_${entityToUpperCaseOutInitial(entity)}.id_${entity});
				  } else {
					this._notificationService.error(
					  '¡Error interno!, consulte al administrador.'
					);
				  }
				},
				error: (error: { error: MessageAPI }) => {
				  console.log(error);
				  this._notificationService.error(
					!error.error
					  ? '¡Error interno!, consulte al administrador.'
					  : !error.error.description
					  ? '¡Error interno!, consulte al administrador.'
					  : error.error.description
				  );
				},
			  });
        }
		this._layoutService.setOpenModal(false);
      });
  }
  ${function_enum}/**
   * Track by function for ngFor loops
   * @param index
   * @param item
   */
  trackByFn(index: number, item: any): any {
    return item.id || index;
  }
}`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentListComponent);
	}
};

const generateDetailsHtml = (basePath: string, entity: string, columns: []) => {
	const pathToCreate: string = `${basePath}details/details.component.html`;

	let attributesView: string = '';
	let attributesForm: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_id: string = column_name.substring(0, 3);
		const column_entity: string = column_name.substring(3, column_name.length);

		attributesView += `${
			column_name != `id_${entity}` && column_name != `deleted_${entity}`
				? ` <!-- ${column_name} -->
	<ng-container *ngIf="${entityToUpperCaseOutInitial(entity)}.${column_name}">
		<div class="flex sm:items-center">
			<mat-icon [svgIcon]="'heroicons_outline:credit-card'"></mat-icon>
			<div class="ml-6 leading-6">{{${
				column_id == 'id_'
					? `selected${entityToUpperCase(column_entity)}.name_${column_entity}`
					: `${entityToUpperCaseOutInitial(entity)}.${column_name}`
			}}}</div>
		</div>
	</ng-container>`
				: ''
		}`;

		attributesForm += `${
			column_name != `id_${entity}` && column_name != `deleted_${entity}`
				? `<!-- ${column_name} -->
				${
					column_id == 'id_'
						? `<div class="mt-8">
                        <mat-form-field class="angel-mat-no-subscript w-full">
                            <mat-label>${entityToUpperCase(
															column_entity
														)}</mat-label>
                            <mat-select [formControlName]="'${column_name}'"
                                [value]="selected${entityToUpperCase(
																	column_entity
																)}.${column_name}">
                                <ng-container *ngFor="let element of list${entityToUpperCase(
																	column_entity
																)}">
                                    <mat-option [value]="element.${column_name}">
                                        {{element.name_${column_name.substring(
																					3,
																					column_name.length
																				)}}}</mat-option>
                                </ng-container>
                            </mat-select>
                        </mat-form-field>
                    </div>`
						: `<div class="mt-8">
					<mat-form-field class="angel-mat-no-subscript w-full">
						<mat-label>${entityToUpperCaseOutInitial(column_name)}</mat-label>
						<mat-icon matPrefix class="hidden sm:flex icon-size-5"
							[svgIcon]="'heroicons_solid:credit-card'"></mat-icon>
						<input matInput ${
							column_type == 'numeric'
								? `maxlength="${item.lenght_numeric_}"`
								: `${
										column_type == 'character varying'
											? `maxlength="${item.length_character_}"`
											: ''
								  }`
						} [formControlName]="'${column_name}'"
							[placeholder]="'${column_name}'" [spellcheck]="false">
					</mat-form-field>
				</div>	`
				}`
				: ''
		}`;
	});

	const contentDetailsHtml: string = `<div class="flex flex-col w-full">
    <!-- View mode -->
    <ng-container *ngIf="!editMode">
        <!-- Header -->
        <div class="relative w-full h-40 flex items-center bg-accent-100 dark:bg-accent-700 place-content-center">
            <!-- Background -->
            <div class="w-full h-40 bg-black z-10 opacity-0">
            </div>
            <h1 class="absolute z-20 text-dark text-3xl">{{nameEntity}}
            </h1>
            <!-- Light version -->
            <img class="dark:hidden absolute inset-0 object-cover w-full h-full" src="assets/images/background.svg">
            <!-- Dark version -->
            <img class="hidden dark:flex absolute inset-0 object-cover w-full h-full"
                src="assets/images/background-on-dark.svg">
        </div>
        <!-- Entity -->
        <div class="relative flex flex-col flex-auto items-center p-6 pt-0 sm:p-12 sm:pt-0">
            <div class="w-full max-w-3xl">
                <!-- Actions -->
                <div class="flex items-center -mx-6 sm:-mx-12 py-4 pr-6 pl-6 sm:pr-12 sm:pl-12 border-t bg-gray-100 dark:bg-transparent rounded-t-none rounded-b-2xl">
                    <button mat-stroked-button (click)="toggleEditMode(true)">
                        <mat-icon class="icon-size-5" [svgIcon]="'heroicons_solid:pencil-alt'"></mat-icon>
                        <span class="ml-1">Editar</span>
                    </button>
                    <button mat-stroked-button class="ml-auto" [matTooltip]="'Cerrar'" [routerLink]="['../']">
                        <mat-icon class="icon-size-5" [svgIcon]="'heroicons_outline:x'"></mat-icon>
                        <span class="ml-1">Cerrar</span>
                    </button>
                </div>
                <div class="flex flex-col mt-4 pt-6 space-y-8">
					${attributesView}
                </div>
            </div>
        </div>
    </ng-container>

    <!-- Edit mode -->
    <ng-container *ngIf="editMode">
        <!-- Header -->
        <div class="relative w-full h-40 flex items-center bg-accent-100 dark:bg-accent-700 place-content-center">
            <!-- Background -->
            <div class="w-full h-40 bg-black z-10 opacity-25">
            </div>
            <h1 class="absolute z-20 text-dark text-3xl">{{nameEntity}}
            </h1>
            <!-- Light version -->
            <img class="dark:hidden absolute inset-0 object-cover w-full h-full" src="assets/images/background.svg">
            <!-- Dark version -->
            <img class="hidden dark:flex absolute inset-0 object-cover w-full h-full"
                src="assets/images/background-on-dark.svg">
        </div>
        <!-- form -->
        <div class="relative flex flex-col flex-auto items-center px-6 sm:px-12">
            <div class="w-full max-w-3xl">
                <!-- Actions -->
                <div class="flex items-center -mx-6 sm:-mx-12 py-4 pr-6 pl-6 sm:pr-12 sm:pl-12 border-t bg-gray-100 dark:bg-transparent rounded-t-none rounded-b-2xl">
                    <!-- Save -->
                    <button mat-flat-button [color]="'primary'" [disabled]="${entityToUpperCaseOutInitial(
											entity
										)}Form.invalid"
                        [matTooltip]="'Guardar'" (click)="update${entityToUpperCase(
													entity
												)}()">
                        Guardar
                    </button>
                    <!-- Delete -->
                    <button mat-stroked-button class="ml-2" [color]="'warn'" [matTooltip]="'Eliminar'"
                        (click)="delete${entityToUpperCase(entity)}()">
                        Eliminar
                    </button>
                    <!-- Cancel -->
                    <button mat-stroked-button class="ml-2 mr-2" [matTooltip]="'Cancelar'"
                        (click)="toggleEditMode(false)">
                        Cancelar
                    </button>

                    <button mat-stroked-button class="ml-auto" [matTooltip]="'Cerrar'" [routerLink]="['../']">
                        <mat-icon class="icon-size-5" [svgIcon]="'heroicons_outline:x'"></mat-icon>
                        <span class="ml-1">Cerrar</span>
                    </button>
                </div>
                <form [formGroup]="${entityToUpperCaseOutInitial(
									entity
								)}Form" class="mb-8">
						<!-- Alert -->
                    <angel-alert class="mt-8" *ngIf="${entityToUpperCaseOutInitial(
											entity
										)}Form.invalid || showAlert"
                        [appearance]="'outline'" [showIcon]="false" [type]="alert.type"
                        [@shake]="alert.type === 'error'">
                        <!-- MessageAPI if alert is actived for the component -->
                        {{alert.message}}
                        <!-- name_control -->
                        <mat-error *ngIf="${entityToUpperCaseOutInitial(
													entity
												)}Form.get('name_control')?.hasError('required')">
                            • Ingrese name_control
                        </mat-error>
                        <mat-error *ngIf="${entityToUpperCaseOutInitial(
													entity
												)}Form.get('name_control')?.hasError('maxlength')">
                            • longitud maxima name_control
                        </mat-error>
                        <mat-error *ngIf="${entityToUpperCaseOutInitial(
													entity
												)}Form.get('name_control')?.hasError('minlength')">
                            • longitud minima name_control
                        </mat-error>
                    </angel-alert>
                    <!-- Alert -->
					${attributesForm}
                </form>
            </div>
        </div>
    </ng-container>
</div>
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentDetailsHtml);
	}
};

const generateDetailsComponent = (
	basePath: string,
	entity: string,
	nameVisibility: string,
	columns: []
) => {
	const pathToCreate: string = `${basePath}details/details.component.ts`;

	let form: string = '';
	let selected: string = '';
	let selectedServices: string = '';
	let selectedSubscribe: string = '';
	let otherIDs: string = '';
	let patchForm: string = '';
	let type_enum: string = '';
	let select_enum: string = '';
	let function_enum: string = '';

	columns.map((item: any) => {
		const column_name: string = item.column_name_;
		const column_type: string = item.column_type_;
		const column_udt_name: string = item.column_udt_name_;
		const column_id: string = column_name.substring(0, 3);
		const column_entity: string = column_name.substring(3, column_name.length);

		if (column_type === 'USER-DEFINED') {
			type_enum += `
			/**
			 * Type Enum ${column_udt_name}
			 */
			 ${entityToUpperCaseOutInitial(
					column_name
				)}: ${column_udt_name}_ENUM[] = _${entityToUpperCaseOutInitial(
				column_name
			)};

			${entityToUpperCaseOutInitial(column_name)}Select!: ${column_udt_name}_ENUM;
			
			 /**
			  * Type Enum ${column_udt_name}
			  */
			`;

			select_enum += `
			/**
			 * Type Enum ${column_udt_name}
			 */
			this.${entityToUpperCaseOutInitial(
				column_name
			)}Select = this.${entityToUpperCaseOutInitial(column_name)}.find(
			  (${column_entity}) => ${column_entity}.value_type == this.${entity}.${column_name}
			)!;
			/**
			 * Type Enum ${column_udt_name}
			 */
			`;

			function_enum += `/**
			 * getType${entityToUpperCase(entity)}Enum
			 */
			getType${entityToUpperCase(
				entity
			)}Enum(${column_name}: ${column_udt_name}): ${column_udt_name}_ENUM {
			  return this.${entityToUpperCaseOutInitial(column_name)}.find(
				(${column_entity}) => ${column_entity}.value_type == ${column_name}
			  )!;
			}
			`;
		}

		otherIDs += `${
			column_id == 'id_' && column_entity != entity
				? `${column_entity}: {
					${column_name}: parseInt(${entityToUpperCaseOutInitial(entity)}.${column_name}),
				},`
				: ''
		}`;

		form += `${
			column_name == `deleted_${entity}`
				? ''
				: `${column_name}:${
						column_name == `id_${entity}`
							? "['']"
							: `['',[Validators.required ${
									column_name != `id_${entity}` && column_id == 'id_'
										? ''
										: column_type == 'numeric'
										? `,Validators.maxLength(${item.lenght_numeric_})`
										: `${
												column_type == 'character varying'
													? `,Validators.maxLength(${item.length_character_})`
													: ''
										  }`
							  }]]`
				  },`
		}`;

		selected += `${
			column_name != `id_${entity}` && column_id == 'id_'
				? `
				
				 list${entityToUpperCase(column_entity)}: ${entityToUpperCase(
						column_entity
				  )}[] = [];
				 selected${entityToUpperCase(column_entity)}: ${entityToUpperCase(
						column_entity
				  )} = ${entityToUpperCaseOutInitial(column_entity)};
				
				`
				: ''
		}`;

		selectedServices += `${
			column_name != `id_${entity}` && column_id == 'id_'
				? `private _${entityToUpperCaseOutInitial(
						column_entity
				  )}Service: ${entityToUpperCase(column_entity)}Service,`
				: ''
		}`;

		selectedSubscribe += `${
			column_name != `id_${entity}` && column_id == 'id_'
				? `
				// ${entityToUpperCase(column_entity)}
				this._${entityToUpperCaseOutInitial(column_entity)}Service
				.queryRead('*')
				.pipe(takeUntil(this._unsubscribeAll))
				.subscribe((${column_name.substring(
					3,
					column_name.length
				)}s: ${entityToUpperCase(column_entity)}[]) => {
					this.list${entityToUpperCase(column_entity)} = ${column_entity}s;

					this.selected${entityToUpperCase(column_entity)} = this.list${entityToUpperCase(
						column_entity
				  )}.find(
					(item) =>
						item.${column_name} ==
						this.${entityToUpperCaseOutInitial(entity)}.${column_name.substring(
						3,
						column_name.length
				  )}.${column_name}.toString()
					)!;
				});
				`
				: ''
		}`;

		patchForm += `${
			column_id == 'id_' && column_entity != entity
				? `${column_name}: this.${entityToUpperCaseOutInitial(
						entity
				  )}.${column_entity}.${column_name},`
				: ''
		}`;
	});

	const contentDetailsComponent: string = `import { OverlayRef } from '@angular/cdk/overlay';
	import { DOCUMENT } from '@angular/common';
	import { ChangeDetectorRef, Component, OnInit , Inject} from '@angular/core';
	import { FormBuilder, FormGroup, Validators } from '@angular/forms';
	import { MatDrawerToggleResult } from '@angular/material/sidenav';
	import { ActivatedRoute, Router } from '@angular/router';
	import { Store } from '@ngrx/store';
	import { filter, fromEvent, merge,Subject, takeUntil } from 'rxjs';
	import { angelAnimations } from '@angel/animations';
	import { AngelAlertType } from '@angel/components/alert';
	import { MessageAPI, AppInitialData } from 'app/core/app/app.type';
	import { LayoutService } from 'app/layout/layout.service';
	import { ActionAngelConfirmation, AngelConfirmationService} from '@angel/services/confirmation';
	import { NotificationService } from 'app/shared/notification/notification.service';
	import { ${entityToUpperCase(
		entity
	)}Service } from '../${entityReplaceUnderscore(entity)}.service';
	import { ${entityToUpperCase(entity)} } from '../${entityReplaceUnderscore(
		entity
	)}.types';
	import { ${entityToUpperCase(
		entity
	)}ListComponent } from '../list/list.component';
	
	@Component({
	  selector: '${entityReplaceUnderscore(entity)}-details',
	  templateUrl: './details.component.html',
  	  animations: angelAnimations,
	})
	export class ${entityToUpperCase(entity)}DetailsComponent implements OnInit {

	  ${selected}
	
	  nameEntity: string = '${nameVisibility}';
	  private data!: AppInitialData;

	  ${type_enum}
	
	  editMode: boolean = false;
	  /**
	   * Alert
	   */
	  alert: { type: AngelAlertType; message: string } = {
		  type: 'error',
		  message: '',
	  };
	  showAlert: boolean = false;
	  /**
	   * Alert
	   */
	  ${entityToUpperCaseOutInitial(entity)}!: ${entityToUpperCase(entity)};
	  ${entityToUpperCaseOutInitial(entity)}Form!: FormGroup;
	  private ${entityToUpperCaseOutInitial(entity)}s!: ${entityToUpperCase(
		entity
	)}[];
	
	  private _tagsPanelOverlayRef!: OverlayRef;
	  private _unsubscribeAll: Subject<any> = new Subject<any>();
	  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
	  /**
	   * Constructor
	   */
	  constructor(
		private _store: Store<{ global: AppInitialData }>,
		private _changeDetectorRef: ChangeDetectorRef,
		private _${entityToUpperCaseOutInitial(
			entity
		)}ListComponent: ${entityToUpperCase(entity)}ListComponent,
		private _${entityToUpperCaseOutInitial(entity)}Service: ${entityToUpperCase(
		entity
	)}Service,
    	@Inject(DOCUMENT) private _document: any,
		private _formBuilder: FormBuilder,
		private _activatedRoute: ActivatedRoute,
		private _router: Router,
		private _notificationService: NotificationService,
		private _angelConfirmationService: AngelConfirmationService,
		private _layoutService: LayoutService,
		${selectedServices}
	  ) {}
	
	  /** ----------------------------------------------------------------------------------------------------- */
	  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

	  /**
	   * On init
	   */
	  ngOnInit(): void {
		/**
		 * isOpenModal
		 */
		this._layoutService.isOpenModal$
		  .pipe(takeUntil(this._unsubscribeAll))
		  .subscribe((_isOpenModal: boolean) => {
			this.isOpenModal = _isOpenModal;
		  });
		/**
		 * isOpenModal
		 */
		/**
		 * Subscribe to user changes of state
		 */
		this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
		  this.data = state.global;
		});
		/**
			 * Open the drawer
			 */
		this._${entityToUpperCaseOutInitial(entity)}ListComponent.matDrawer.open();
		/**
		 * Create the ${entityToUpperCaseOutInitial(entity)} form
		 */
		this.${entityToUpperCaseOutInitial(entity)}Form = this._formBuilder.group({
			${form}
		});
		/**
		 * Get the ${entityToUpperCaseOutInitial(entity)}s
		 */
		this._${entityToUpperCaseOutInitial(
			entity
		)}Service.${entityToUpperCaseOutInitial(entity)}s$
		  .pipe(takeUntil(this._unsubscribeAll))
		  .subscribe((${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
			this.${entityToUpperCaseOutInitial(entity)}s = ${entityToUpperCaseOutInitial(
		entity
	)}s;
			/**
			 * Mark for check
			 */
			this._changeDetectorRef.markForCheck();
		  });
		  /**
		   * Get the ${entityToUpperCaseOutInitial(entity)}
		   */
		this._${entityToUpperCaseOutInitial(
			entity
		)}Service.${entityToUpperCaseOutInitial(entity)}$
		  .pipe(takeUntil(this._unsubscribeAll))
		  .subscribe((${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
			/**
			 * Open the drawer in case it is closed
			 */
			this._${entityToUpperCaseOutInitial(entity)}ListComponent.matDrawer.open();
			/**
			 * Get the ${entityToUpperCaseOutInitial(entity)}
			 */
			this.${entityToUpperCaseOutInitial(entity)} = ${entityToUpperCaseOutInitial(
		entity
	)};
				${select_enum}
				${selectedSubscribe}
				/**
				 * Patch values to the form
				 */
			this.patchForm();
			/**
			 * Toggle the edit mode off
			 */
			this.toggleEditMode(false);
			/**
			 * Mark for check
			 */
			this._changeDetectorRef.markForCheck();
		  });
		  /**
     * Shortcuts
     */
    merge(
      fromEvent(this._document, 'keydown').pipe(
        takeUntil(this._unsubscribeAll),
        filter<KeyboardEvent | any>((e) => e.key === 'Escape')
      )
    )
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((keyUpOrKeyDown) => {
        console.log(keyUpOrKeyDown);
        /**
         * Shortcut Escape
         */
       if (!this.isOpenModal && keyUpOrKeyDown.key == 'Escape') {
          /**
           * Navigate parentUrl
           */
          const parentUrl = this._router.url.split('/').slice(0, -1).join('/');
          this._router.navigate([parentUrl]);
          /**
           * Close Drawer
           */
          this.closeDrawer();
        }
      });
    /**
     * Shortcuts
     */
	  }
	  /**
	   * Pacth the form with the information of the database
	   */
	  patchForm(): void {
		this.${entityToUpperCaseOutInitial(entity)}Form.patchValue(${
		patchForm
			? `{...this.${entityToUpperCaseOutInitial(entity)},${patchForm}}`
			: `this.${entityToUpperCaseOutInitial(entity)}`
	});
	  }
	  /**
	   * On destroy
	   */
	  ngOnDestroy(): void {
		/**
		 * Unsubscribe from all subscriptions
		 */
		this._unsubscribeAll.next(0);
		this._unsubscribeAll.complete();
		/**
		 * Dispose the overlays if they are still on the DOM
		 */
		if (this._tagsPanelOverlayRef) {
		  this._tagsPanelOverlayRef.dispose();
		}
	  }
	
	  /** ----------------------------------------------------------------------------------------------------- */
	  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */

	  /**
	   * Close the drawer
	   */
	  closeDrawer(): Promise<MatDrawerToggleResult> {
		return this._${entityToUpperCaseOutInitial(
			entity
		)}ListComponent.matDrawer.close();
	  }
	  /**
	   * Toggle edit mode
	   * @param editMode
	   */
	  toggleEditMode(editMode: boolean | null = null): void {
		this.patchForm();

		if (editMode === null) {
		  this.editMode = !this.editMode;
		} else {
		  this.editMode = editMode;
		}
		/**
		 * Mark for check
		 */
		this._changeDetectorRef.markForCheck();
	  }
	
	  /**
	   * Update the ${entityToUpperCaseOutInitial(entity)}
	   */
	  update${entityToUpperCase(entity)}(): void {
		/**
		 * Get the ${entityToUpperCaseOutInitial(entity)}
		 */
		const id_user_ = this.data.user.id_user;
		let ${entityToUpperCaseOutInitial(entity)} = this.${entityToUpperCaseOutInitial(
		entity
	)}Form.getRawValue();
		/**
		 * Delete whitespace (trim() the atributes type string)
		 */
		 ${entityToUpperCaseOutInitial(entity)} = {...${entityToUpperCaseOutInitial(
		entity
	)},id_user_: parseInt(id_user_),
	id_${entity}: parseInt(${entityToUpperCaseOutInitial(
		entity
	)}.id_${entity}), ${otherIDs}}
		/**
		 * Update
		 */
		this._${entityToUpperCaseOutInitial(entity)}Service
		  .update(${entityToUpperCaseOutInitial(entity)})
		  .pipe(takeUntil(this._unsubscribeAll))
		  .subscribe({
			next: (_${entityToUpperCaseOutInitial(entity)}: ${entityToUpperCase(
		entity
	)}) => {
			  console.log(_${entityToUpperCaseOutInitial(entity)});
			  if (_${entityToUpperCaseOutInitial(entity)}) {
				this._notificationService.success(
				  '${nameVisibility} actualizada correctamente'
				);
				/**
				 * Toggle the edit mode off
				 */
				this.toggleEditMode(false);
			  } else {
				this._notificationService.error(
				  '¡Error interno!, consulte al administrador.'
				);
			  }
			},
			error: (error: { error: MessageAPI }) => {
			  console.log(error);
			  this._notificationService.error(
				!error.error
				  ? '¡Error interno!, consulte al administrador.'
				  : !error.error.description
				  ? '¡Error interno!, consulte al administrador.'
				  : error.error.description
			  );
			},
		  });
	  }
	  /**
	   * Delete the ${entityToUpperCaseOutInitial(entity)}
	   */
	  delete${entityToUpperCase(entity)}(): void {
		this._angelConfirmationService
		  .open({
				title: 'Eliminar ${entityToLowerCase(nameVisibility)}',
				message: '¿Estás seguro de que deseas eliminar esta ${entityToLowerCase(
					nameVisibility
				)}? ¡Esta acción no se puede deshacer!',
			})
		  .afterClosed()
		  .pipe(takeUntil(this._unsubscribeAll))
		  .subscribe((confirm: ActionAngelConfirmation) => {
			if (confirm === 'confirmed') {
				/**
				 * Get the current ${entityToUpperCaseOutInitial(entity)}'s id
				 */
			  const id_user_ = this.data.user.id_user;
			  const id_${entity} = this.${entityToUpperCaseOutInitial(entity)}.id_${entity};
			  /**
				* Get the next/previous ${entityToUpperCaseOutInitial(entity)}'s id
				*/
			  const currentIndex = this.${entityToUpperCaseOutInitial(entity)}s.findIndex(
				(item) => item.id_${entity} === id_${entity}
			  );
	
			  const nextIndex =
				currentIndex +
				(currentIndex === this.${entityToUpperCaseOutInitial(
					entity
				)}s.length - 1 ? -1 : 1);
			  const nextId =
				this.${entityToUpperCaseOutInitial(entity)}s.length === 1 &&
				this.${entityToUpperCaseOutInitial(entity)}s[0].id_${entity} === id_${entity}
				  ? null
				  : this.${entityToUpperCaseOutInitial(entity)}s[nextIndex].id_${entity};
				  /**
				   * Delete
				   */
			  this._${entityToUpperCaseOutInitial(entity)}Service
				.delete(id_user_, id_${entity})
				.pipe(takeUntil(this._unsubscribeAll))
				.subscribe({
					next: (response: boolean) => {
					  console.log(response);
					  if (response) {
						/**
						 * Return if the ${entityToUpperCaseOutInitial(entity)} wasn't deleted...
						 */
						this._notificationService.success(
						  '${nameVisibility} eliminada correctamente'
						);
						/**
						 * Get the current activated route
						 */
						let route = this._activatedRoute;
						while (route.firstChild) {
						  route = route.firstChild;
						}
						/**
						 * Navigate to the next ${entityToUpperCaseOutInitial(entity)} if available
						 */
						if (nextId) {
						  this._router.navigate(['../', nextId], {
							relativeTo: route,
						  });
						}
						/**
						 * Otherwise, navigate to the parent
						 */
						else {
						  this._router.navigate(['../'], { relativeTo: route });
						}
						/**
						 * Toggle the edit mode off
						 */
						this.toggleEditMode(false);
					  } else {
						this._notificationService.error(
						  '¡Error interno!, consulte al administrador.'
						);
					  }
					},
					error: (error: { error: MessageAPI }) => {
					  console.log(error);
					  this._notificationService.error(
						!error.error
						  ? '¡Error interno!, consulte al administrador.'
						  : !error.error.description
						  ? '¡Error interno!, consulte al administrador.'
						  : error.error.description
					  );
					},
				  });
				  /**
				   * Mark for check
				   */
			  this._changeDetectorRef.markForCheck();
			}
			this._layoutService.setOpenModal(false);
		  });
	  }
	  ${function_enum}
	}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentDetailsComponent);
	}
};

const generateGuard = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.guards.ts`;

	const contentGuard: string = `
	import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanDeactivate,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { ${entityToUpperCase(
		entity
	)}DetailsComponent } from './details/details.component';

@Injectable({
  providedIn: 'root',
})
export class CanDeactivate${entityToUpperCase(entity)}Details
  implements CanDeactivate<${entityToUpperCase(entity)}DetailsComponent>
{
  canDeactivate(
    component: ${entityToUpperCase(entity)}DetailsComponent,
    currentRoute: ActivatedRouteSnapshot,
    currentState: RouterStateSnapshot,
    nextState: RouterStateSnapshot
  ):
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree>
    | boolean
    | UrlTree {
	/**
	 * Get the next route
	 */
    let nextRoute: ActivatedRouteSnapshot = nextState.root;
    while (nextRoute.firstChild) {
      nextRoute = nextRoute.firstChild;
    }
	/**
	 * If the next state doesn't contain '/${entityReplaceUnderscore(entity)}'
	 * it means we are navigating away from the
	 * ${entity} app
	*/
    if (!nextState.url.includes('/${entityReplaceUnderscore(entity)}')) {
	/**
	 * Let it navigate
	 */
      return true;
    }
	/**
	 * If we are navigating to another
	 */
    if (nextRoute.paramMap.get('id_${entity}')) {
	/**
	 * Just navigate
	 */
      return true;
    }
    else {
	/**
	 * Close the drawer first, and then navigate
	 */
      return component.closeDrawer().then(() => {
        return true;
      });
    }
  }
}
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentGuard);
	}
};

const generateRouting = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.routing.ts`;

	const contentRouting: string = `
	import { Route } from '@angular/router';
import { ${entityToUpperCase(
		entity
	)}DetailsComponent } from './details/details.component';
import { ${entityToUpperCase(
		entity
	)}Component } from './${entityReplaceUnderscore(entity)}.component';
import { CanDeactivate${entityToUpperCase(
		entity
	)}Details } from './${entityReplaceUnderscore(entity)}.guards';
import { ${entityToUpperCase(
		entity
	)}Resolver } from './${entityReplaceUnderscore(entity)}.resolvers';
import { ${entityToUpperCase(
		entity
	)}ListComponent } from './list/list.component';

export const ${entityToUpperCaseOutInitial(entity)}Routes: Route[] = [
  {
    path: '',
    component: ${entityToUpperCase(entity)}Component,
    children: [
      {
        path: '',
        component: ${entityToUpperCase(entity)}ListComponent,
        children: [
          {
            path: ':id_${entity}',
            component: ${entityToUpperCase(entity)}DetailsComponent,
            resolve: {
              task: ${entityToUpperCase(entity)}Resolver,
            },
            canDeactivate: [CanDeactivate${entityToUpperCase(entity)}Details],
          },
        ],
      },
    ],
  },
];
	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentRouting);
	}
};

const generateModule = (basePath: string, entity: string) => {
	const pathToCreate: string = `${basePath}${entityReplaceUnderscore(
		entity
	)}.module.ts`;

	const contentModule: string = `
	import { NgModule } from '@angular/core';
import { MatMomentDateModule } from '@angular/material-moment-adapter';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatRippleModule, MAT_DATE_FORMATS } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDividerModule } from '@angular/material/divider';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatMenuModule } from '@angular/material/menu';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { RouterModule } from '@angular/router';
import * as moment from 'moment';
import { AngelFindByKeyPipeModule } from '@angel/pipes/find-by-key';
import { SharedModule } from 'app/shared/shared.module';
import { AngelAlertModule } from '@angel/components/alert';
import { ${entityToUpperCase(
		entity
	)}DetailsComponent } from './details/details.component';
import { ${entityToUpperCase(
		entity
	)}Component } from './${entityReplaceUnderscore(entity)}.component';
import { ${entityToUpperCaseOutInitial(
		entity
	)}Routes } from './${entityReplaceUnderscore(entity)}.routing';
import { ${entityToUpperCase(
		entity
	)}ListComponent } from './list/list.component';
import { MatDialogModule } from '@angular/material/dialog';
import { ModalSelect${entityToUpperCase(
		entity
	)}Component } from './modal-select-${entityReplaceUnderscore(
		entity
	)}/modal-select-${entityReplaceUnderscore(entity)}.component';

@NgModule({
  declarations: [
    ${entityToUpperCase(entity)}ListComponent,
    ${entityToUpperCase(entity)}DetailsComponent,
    ${entityToUpperCase(entity)}Component,
	ModalSelect${entityToUpperCase(entity)}Component
  ],
  imports: [
    RouterModule.forChild(${entityToUpperCaseOutInitial(entity)}Routes),
    MatButtonModule,
    MatCheckboxModule,
    MatDatepickerModule,
    MatDividerModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatMenuModule,
    MatMomentDateModule,
	MatDialogModule,
    MatProgressBarModule,
    MatRadioModule,
    MatRippleModule,
    MatSelectModule,
    MatSidenavModule,
    MatTableModule,
    MatTooltipModule,
    AngelFindByKeyPipeModule,
	AngelAlertModule,
    SharedModule,
  ],
  providers: [
    {
      provide: MAT_DATE_FORMATS,
      useValue: {
        parse: {
          dateInput: moment.ISO_8601,
        },
        display: {
          dateInput: 'LL',
          monthYearLabel: 'MMM YYYY',
          dateA11yLabel: 'LL',
          monthYearA11yLabel: 'MMMM YYYY',
        },
      },
    },
  ],
})
export class ${entityToUpperCase(entity)}Module {}

	`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreate)) {
		fs.writeFileSync(`${pathToCreate}`, contentModule);
	}
};

const generateModalSelect = (
	basePath: string,
	entity: string,
	nameVisibility: string
) => {
	const pathToCreateService: string = `${basePath}modal-select-${entityReplaceUnderscore(
		entity
	)}/modal-select-${entityReplaceUnderscore(entity)}.service.ts`;
	const pathToCreateComponent: string = `${basePath}modal-select-${entityReplaceUnderscore(
		entity
	)}/modal-select-${entityReplaceUnderscore(entity)}.component.ts`;
	const pathToCreateTemplate: string = `${basePath}modal-select-${entityReplaceUnderscore(
		entity
	)}/modal-select-${entityReplaceUnderscore(entity)}.component.html`;

	const contentService: string = `
import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { LayoutService } from 'app/layout/layout.service';
import { ModalSelect${entityToUpperCase(
		entity
	)}Component } from './modal-select-${entityReplaceUnderscore(
		entity
	)}.component';

@Injectable({
  providedIn: 'root',
})
export class ModalSelect${entityToUpperCase(entity)}Service {
  constructor(
    private _dialog: MatDialog,
    private _layoutService: LayoutService
  ) {}
  dialogRef: any;

  openModalSelect${entityToUpperCase(entity)}() {
    this._layoutService.setOpenModal(true);

    return (this.dialogRef = this._dialog.open(ModalSelect${entityToUpperCase(
			entity
		)}Component, {
      minHeight: 'inherit',
      maxHeight: 'inherit',
      height: 'auto',
      width: '32rem',
      maxWidth: '',
      panelClass: ['mat-dialog-cont'],
      data: {},
      disableClose: true,
    }));
  }

  closeModalSelect${entityToUpperCase(entity)}() {
    this.dialogRef.close();
  }
}`;
	const contentComponent: string = `
import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ${entityToUpperCase(
		entity
	)}Service } from '../${entityReplaceUnderscore(entity)}.service';
import { ${entityToUpperCase(entity)} } from '../${entityReplaceUnderscore(
		entity
	)}.types';
import { ModalSelect${entityToUpperCase(
		entity
	)}Service } from './modal-select-${entityReplaceUnderscore(entity)}.service';

@Component({
  selector: 'app-modal-select-${entityReplaceUnderscore(entity)}',
  templateUrl: './modal-select-${entityReplaceUnderscore(
		entity
	)}.component.html',
})
export class ModalSelect${entityToUpperCase(
		entity
	)}Component implements OnInit {
  id_${entity}: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  list${entityToUpperCase(entity)}: ${entityToUpperCase(entity)}[] = [];
  select${entityToUpperCase(entity)}Form!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _${entityToUpperCaseOutInitial(entity)}Service: ${entityToUpperCase(
		entity
	)}Service,
    private _modalSelect${entityToUpperCase(
			entity
		)}Service: ModalSelect${entityToUpperCase(entity)}Service
  ) {}

  ngOnInit(): void {
    /**
     * get the list of ${entityToUpperCaseOutInitial(entity)}
     */
    this._${entityToUpperCaseOutInitial(entity)}Service
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_${entityToUpperCaseOutInitial(entity)}s: ${entityToUpperCase(
		entity
	)}[]) => {
        this.list${entityToUpperCase(entity)} = _${entityToUpperCaseOutInitial(
		entity
	)}s;
      });
    /**
     * form
     */
    this.select${entityToUpperCase(entity)}Form = this._formBuilder.group({
      id_${entity}: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.select${entityToUpperCase(entity)}Form.patchValue({
      id_${entity}: this.select${entityToUpperCase(
		entity
	)}Form.getRawValue().id_${entity},
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_${entity} = this.select${entityToUpperCase(
		entity
	)}Form.getRawValue().id_${entity};
    this.patchForm();
  }
  /**
   * closeModalSelect${entityToUpperCase(entity)}
   */
  closeModalSelect${entityToUpperCase(entity)}(): void {
    this._modalSelect${entityToUpperCase(
			entity
		)}Service.closeModalSelect${entityToUpperCase(entity)}();
  }
}`;
	const contentTemplate: string = `
<div class="relative flex flex-col w-full h-full">

    <!-- Header -->
    <div class="flex flex-0 items-center justify-between h-16 pr-3 sm:pr-5 pl-6 sm:pl-8 bg-primary text-on-primary">
        <div class="text-lg">Seleccionar un ${entityToLowerCase(
					nameVisibility
				)}</div>
        <button mat-icon-button (click)="closeModalSelect${entityToUpperCase(
					entity
				)}()" [tabIndex]="-1">
            <mat-icon class="text-current" [svgIcon]="'heroicons_outline:x'"></mat-icon>
        </button>
    </div>
    <!-- Edit ${entityToUpperCaseOutInitial(entity)} -->
    <form class="flex flex-col flex-auto p-6 sm:p-8 overflow-y-auto" [formGroup]="select${entityToUpperCase(
			entity
		)}Form">
        <!-- ${entityToUpperCaseOutInitial(entity)} -->
        <div>
            <mat-form-field class="angel-mat-no-subscript w-full">
                <mat-label>${nameVisibility}s</mat-label>
                <mat-select [formControlName]="'id_${entity}'" (selectionChange)="changeSelect()">
                    <mat-option *ngFor="let element of list${entityToUpperCase(
											entity
										)}" [value]="element.id_${entity}"
                        [matTooltip]="element.id_${entity}">
                        {{element.id_${entity}}}
                    </mat-option>
                </mat-select>
            </mat-form-field>
        </div>
        <div class="flex items-center justify-center sm:justify-end py-2 space-x-3 ng-star-inserted br-10 pt-6">
            <!-- Cancel -->
            <button mat-flat-button
                class="mat-focus-indicator mat-flat-button mat-button-base mat-warn ng-star-inserted"
                (click)="closeModalSelect${entityToUpperCase(entity)}()">
                Cancelar
            </button>
            <!-- Send -->
            <button class="order-first sm:order-last" mat-stroked-button [color]="'primary'"
                [disabled]="select${entityToUpperCase(
									entity
								)}Form.invalid" [mat-dialog-close]="id_${entity}">
                Aceptar
            </button>
        </div>
    </form>
</div>`;
	/**
	 * Generate
	 */
	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreateService)) {
		fs.writeFileSync(`${pathToCreateService}`, contentService);
	}

	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreateComponent)) {
		fs.writeFileSync(`${pathToCreateComponent}`, contentComponent);
	}

	if (fs.existsSync(basePath) && !fs.existsSync(pathToCreateTemplate)) {
		fs.writeFileSync(`${pathToCreateTemplate}`, contentTemplate);
	}
};

export { entityFrontendGenerate };

