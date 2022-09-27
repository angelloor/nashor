import { PluginItemColumn } from '../plugin_item_column/plugin_item_column.class';
import { _pluginItemColumn } from '../plugin_item_column/plugin_item_column.data';
import { ProcessItem } from '../process_item/process_item.class';
import { _processItem } from '../process_item/process_item.data';
import {
	dml_column_process_item_create,
	dml_column_process_item_delete,
	dml_column_process_item_update,
	view_column_process_item_by_plugin_item_column_and_process_item_read,
	view_column_process_item_by_plugin_item_column_query_read,
	view_column_process_item_by_process_item_query_read,
	view_column_process_item_query_read,
	view_column_process_item_specific_read,
} from './column_process_item.store';

export class ColumnProcessItem {
	/** Attributes */
	public id_user_?: number;
	public id_column_process_item: number;
	public plugin_item_column: PluginItemColumn;
	public process_item: ProcessItem;
	public value_column_process_item?: string;
	public entry_date_column_process_item?: string;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_column_process_item: number = 0,
		plugin_item_column: PluginItemColumn = _pluginItemColumn,
		process_item: ProcessItem = _processItem,
		value_column_process_item: string = '',
		entry_date_column_process_item: string = ''
	) {
		this.id_user_ = id_user_;
		this.id_column_process_item = id_column_process_item;
		this.plugin_item_column = plugin_item_column;
		this.process_item = process_item;
		this.value_column_process_item = value_column_process_item;
		this.entry_date_column_process_item = entry_date_column_process_item;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_column_process_item(id_column_process_item: number) {
		this.id_column_process_item = id_column_process_item;
	}
	get _id_column_process_item() {
		return this.id_column_process_item;
	}

	set _plugin_item_column(plugin_item_column: PluginItemColumn) {
		this.plugin_item_column = plugin_item_column;
	}
	get _plugin_item_column() {
		return this.plugin_item_column;
	}

	set _process_item(process_item: ProcessItem) {
		this.process_item = process_item;
	}
	get _process_item() {
		return this.process_item;
	}

	set _value_column_process_item(value_column_process_item: string) {
		this.value_column_process_item = value_column_process_item;
	}
	get _value_column_process_item() {
		return this.value_column_process_item!;
	}

	set _entry_date_column_process_item(entry_date_column_process_item: string) {
		this.entry_date_column_process_item = entry_date_column_process_item;
	}
	get _entry_date_column_process_item() {
		return this.entry_date_column_process_item!;
	}

	/** Methods */
	create() {
		return new Promise<ColumnProcessItem>(async (resolve, reject) => {
			await dml_column_process_item_create(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
			await view_column_process_item_query_read(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byPluginItemColumnQueryRead() {
		return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
			await view_column_process_item_by_plugin_item_column_query_read(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byProcessItemQueryRead() {
		return new Promise<ColumnProcessItem[]>(async (resolve, reject) => {
			await view_column_process_item_by_process_item_query_read(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byPluginItemColumnAndProcessItemRead() {
		return new Promise<ColumnProcessItem>(async (resolve, reject) => {
			await view_column_process_item_by_plugin_item_column_and_process_item_read(
				this
			)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ColumnProcessItem>(async (resolve, reject) => {
			await view_column_process_item_specific_read(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ColumnProcessItem>(async (resolve, reject) => {
			await dml_column_process_item_update(this)
				.then((columnProcessItems: ColumnProcessItem[]) => {
					/**
					 * Mutate response
					 */
					const _columnProcessItems = this.mutateResponse(columnProcessItems);

					resolve(_columnProcessItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_column_process_item_delete(this)
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
	 * @param columnProcessItems
	 * @returns
	 */
	private mutateResponse(
		columnProcessItems: ColumnProcessItem[]
	): ColumnProcessItem[] {
		let _columnProcessItems: ColumnProcessItem[] = [];

		columnProcessItems.map((item: any) => {
			let _columnProcessItem: ColumnProcessItem | any = {
				...item,
				plugin_item_column: {
					id_plugin_item_column: item.id_plugin_item_column,
					plugin_item: { id_plugin_item: item.id_plugin_item },
					name_plugin_item_column: item.name_plugin_item_column,
					lenght_plugin_item_column: item.lenght_plugin_item_column,
				},
				process_item: {
					id_process_item: item.id_process_item,
					official: { id_official: item.id_official },
					process: { id_process: item.id_process },
					task: { id_task: item.id_task },
					level: { id_level: item.id_level },
					item: { id_item: item.id_item },
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _columnProcessItem.id_plugin_item_column;
			delete _columnProcessItem.id_plugin_item;
			delete _columnProcessItem.name_plugin_item_column;
			delete _columnProcessItem.lenght_plugin_item_column;
			delete _columnProcessItem.id_process_item;
			delete _columnProcessItem.id_official;
			delete _columnProcessItem.id_process;
			delete _columnProcessItem.id_task;
			delete _columnProcessItem.id_level;
			delete _columnProcessItem.id_item;

			_columnProcessItems.push(_columnProcessItem);
		});

		return _columnProcessItems;
	}
}
