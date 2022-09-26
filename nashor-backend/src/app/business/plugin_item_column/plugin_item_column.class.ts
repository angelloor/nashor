import { PluginItem } from '../plugin_item/plugin_item.class';
import { _pluginItem } from '../plugin_item/plugin_item.data';
import {
	dml_plugin_item_column_create,
	dml_plugin_item_column_delete,
	dml_plugin_item_column_update,
	view_plugin_item_column_by_plugin_item_query_read,
	view_plugin_item_column_query_read,
	view_plugin_item_column_specific_read,
} from './plugin_item_column.store';

export class PluginItemColumn {
	/** Attributes */
	public id_user_?: number;
	public id_plugin_item_column: number;
	public plugin_item: PluginItem;
	public name_plugin_item_column?: string;
	public lenght_plugin_item_column?: number;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_plugin_item_column: number = 0,
		plugin_item: PluginItem = _pluginItem,
		name_plugin_item_column: string = '',
		lenght_plugin_item_column: number = 0
	) {
		this.id_user_ = id_user_;
		this.id_plugin_item_column = id_plugin_item_column;
		this.plugin_item = plugin_item;
		this.name_plugin_item_column = name_plugin_item_column;
		this.lenght_plugin_item_column = lenght_plugin_item_column;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_plugin_item_column(id_plugin_item_column: number) {
		this.id_plugin_item_column = id_plugin_item_column;
	}
	get _id_plugin_item_column() {
		return this.id_plugin_item_column;
	}

	set _plugin_item(plugin_item: PluginItem) {
		this.plugin_item = plugin_item;
	}
	get _plugin_item() {
		return this.plugin_item;
	}

	set _name_plugin_item_column(name_plugin_item_column: string) {
		this.name_plugin_item_column = name_plugin_item_column;
	}
	get _name_plugin_item_column() {
		return this.name_plugin_item_column!;
	}

	set _lenght_plugin_item_column(lenght_plugin_item_column: number) {
		this.lenght_plugin_item_column = lenght_plugin_item_column;
	}
	get _lenght_plugin_item_column() {
		return this.lenght_plugin_item_column!;
	}

	/** Methods */
	create() {
		return new Promise<PluginItemColumn>(async (resolve, reject) => {
			await dml_plugin_item_column_create(this)
				.then((pluginItemColumns: PluginItemColumn[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItemColumns = this.mutateResponse(pluginItemColumns);

					resolve(_pluginItemColumns[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
			await view_plugin_item_column_query_read(this)
				.then((pluginItemColumns: PluginItemColumn[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItemColumns = this.mutateResponse(pluginItemColumns);

					resolve(_pluginItemColumns);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byPluginItemQueryRead() {
		return new Promise<PluginItemColumn[]>(async (resolve, reject) => {
			await view_plugin_item_column_by_plugin_item_query_read(this)
				.then((pluginItemColumns: PluginItemColumn[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItemColumns = this.mutateResponse(pluginItemColumns);

					resolve(_pluginItemColumns);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<PluginItemColumn>(async (resolve, reject) => {
			await view_plugin_item_column_specific_read(this)
				.then((pluginItemColumns: PluginItemColumn[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItemColumns = this.mutateResponse(pluginItemColumns);

					resolve(_pluginItemColumns[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<PluginItemColumn>(async (resolve, reject) => {
			await dml_plugin_item_column_update(this)
				.then((pluginItemColumns: PluginItemColumn[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItemColumns = this.mutateResponse(pluginItemColumns);

					resolve(_pluginItemColumns[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_plugin_item_column_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	/**
	 * Eliminar ids de entidades externas y formatear la informacion en el esquema correspondiente
	 * @param pluginItemColumns
	 * @returns
	 */
	private mutateResponse(
		pluginItemColumns: PluginItemColumn[]
	): PluginItemColumn[] {
		let _pluginItemColumns: PluginItemColumn[] = [];

		pluginItemColumns.map((item: any) => {
			let _pluginItemColumn: PluginItemColumn | any = {
				...item,
				plugin_item: {
					id_plugin_item: item.id_plugin_item,
					company: { id_company: item.id_company },
					name_plugin_item: item.name_plugin_item,
					description_plugin_item: item.description_plugin_item,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _pluginItemColumn.id_plugin_item;
			delete _pluginItemColumn.id_company;
			delete _pluginItemColumn.name_plugin_item;
			delete _pluginItemColumn.description_plugin_item;

			_pluginItemColumns.push(_pluginItemColumn);
		});

		return _pluginItemColumns;
	}
}
