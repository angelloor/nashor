import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import { ItemCategory } from '../item_category/item_category.class';
import { _itemCategory } from '../item_category/item_category.data';
import {
	dml_item_create,
	dml_item_delete,
	dml_item_update,
	view_item_by_company_query_read,
	view_item_by_item_category_query_read,
	view_item_query_read,
	view_item_specific_read,
} from './item.store';

export class Item {
	/** Attributes */
	public id_user_?: number;
	public id_item: number;
	public company: Company;
	public item_category: ItemCategory;
	public name_item?: string;
	public description_item?: string;
	public cpc_item?: string;
	public deleted_item?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_item: number = 0,
		company: Company = _company,
		item_category: ItemCategory = _itemCategory,
		name_item: string = '',
		description_item: string = '',
		cpc_item: string = '',
		deleted_item: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_item = id_item;
		this.company = company;
		this.item_category = item_category;
		this.name_item = name_item;
		this.description_item = description_item;
		this.cpc_item = cpc_item;
		this.deleted_item = deleted_item;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_item(id_item: number) {
		this.id_item = id_item;
	}
	get _id_item() {
		return this.id_item;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _item_category(item_category: ItemCategory) {
		this.item_category = item_category;
	}
	get _item_category() {
		return this.item_category;
	}

	set _name_item(name_item: string) {
		this.name_item = name_item;
	}
	get _name_item() {
		return this.name_item!;
	}

	set _description_item(description_item: string) {
		this.description_item = description_item;
	}
	get _description_item() {
		return this.description_item!;
	}

	set _cpc_item(cpc_item: string) {
		this.cpc_item = cpc_item;
	}
	get _cpc_item() {
		return this.cpc_item!;
	}

	set _deleted_item(deleted_item: boolean) {
		this.deleted_item = deleted_item;
	}
	get _deleted_item() {
		return this.deleted_item!;
	}

	/** Methods */
	create() {
		return new Promise<Item>(async (resolve, reject) => {
			await dml_item_create(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Item[]>(async (resolve, reject) => {
			await view_item_query_read(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Item[]>(async (resolve, reject) => {
			await view_item_by_company_query_read(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byItemCategoryQueryRead() {
		return new Promise<Item[]>(async (resolve, reject) => {
			await view_item_by_item_category_query_read(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Item>(async (resolve, reject) => {
			await view_item_specific_read(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Item>(async (resolve, reject) => {
			await dml_item_update(this)
				.then((items: Item[]) => {
					/**
					 * Mutate response
					 */
					const _items = this.mutateResponse(items);

					resolve(_items[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_item_delete(this)
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
	 * @param items
	 * @returns
	 */
	private mutateResponse(items: Item[]): Item[] {
		let _items: Item[] = [];

		items.map((item: any) => {
			let _item: Item | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				item_category: {
					id_item_category: item.id_item_category,
					company: { id_company: item.id_company },
					name_item_category: item.name_item_category,
					description_item_category: item.description_item_category,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _item.id_company;
			delete _item.id_setting;
			delete _item.name_company;
			delete _item.acronym_company;
			delete _item.address_company;
			delete _item.status_company;
			delete _item.id_item_category;
			delete _item.id_company;
			delete _item.name_item_category;
			delete _item.description_item_category;

			_items.push(_item);
		});

		return _items;
	}
}
