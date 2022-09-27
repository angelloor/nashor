import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_plugin_item_create,
	dml_plugin_item_delete,
	dml_plugin_item_update,
	view_plugin_item_by_company_query_read,
	view_plugin_item_query_read,
	view_plugin_item_specific_read,
} from './plugin_item.store';

export class PluginItem {
	/** Attributes */
	public id_user_?: number;
	public id_plugin_item: number;
	public company: Company;
	public name_plugin_item?: string;
	public description_plugin_item?: string;
	public select_plugin_item?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_plugin_item: number = 0,
		company: Company = _company,
		name_plugin_item: string = '',
		description_plugin_item: string = '',
		select_plugin_item: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_plugin_item = id_plugin_item;
		this.company = company;
		this.name_plugin_item = name_plugin_item;
		this.description_plugin_item = description_plugin_item;
		this.select_plugin_item = select_plugin_item;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_plugin_item(id_plugin_item: number) {
		this.id_plugin_item = id_plugin_item;
	}
	get _id_plugin_item() {
		return this.id_plugin_item;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_plugin_item(name_plugin_item: string) {
		this.name_plugin_item = name_plugin_item;
	}
	get _name_plugin_item() {
		return this.name_plugin_item!;
	}

	set _description_plugin_item(description_plugin_item: string) {
		this.description_plugin_item = description_plugin_item;
	}
	get _description_plugin_item() {
		return this.description_plugin_item!;
	}

	set _select_plugin_item(select_plugin_item: boolean) {
		this.select_plugin_item = select_plugin_item;
	}
	get _select_plugin_item() {
		return this.select_plugin_item!;
	}

	/** Methods */
	create() {
		return new Promise<PluginItem>(async (resolve, reject) => {
			await dml_plugin_item_create(this)
				.then((pluginItems: PluginItem[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItems = this.mutateResponse(pluginItems);

					resolve(_pluginItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<PluginItem[]>(async (resolve, reject) => {
			await view_plugin_item_query_read(this)
				.then((pluginItems: PluginItem[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItems = this.mutateResponse(pluginItems);

					resolve(_pluginItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<PluginItem[]>(async (resolve, reject) => {
			await view_plugin_item_by_company_query_read(this)
				.then((pluginItems: PluginItem[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItems = this.mutateResponse(pluginItems);

					resolve(_pluginItems);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<PluginItem>(async (resolve, reject) => {
			await view_plugin_item_specific_read(this)
				.then((pluginItems: PluginItem[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItems = this.mutateResponse(pluginItems);

					resolve(_pluginItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<PluginItem>(async (resolve, reject) => {
			await dml_plugin_item_update(this)
				.then((pluginItems: PluginItem[]) => {
					/**
					 * Mutate response
					 */
					const _pluginItems = this.mutateResponse(pluginItems);

					resolve(_pluginItems[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_plugin_item_delete(this)
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
	 * @param pluginItems
	 * @returns
	 */
	private mutateResponse(pluginItems: PluginItem[]): PluginItem[] {
		let _pluginItems: PluginItem[] = [];

		pluginItems.map((item: any) => {
			let _pluginItem: PluginItem | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _pluginItem.id_company;
			delete _pluginItem.id_setting;
			delete _pluginItem.name_company;
			delete _pluginItem.acronym_company;
			delete _pluginItem.address_company;
			delete _pluginItem.status_company;

			_pluginItems.push(_pluginItem);
		});

		return _pluginItems;
	}
}
