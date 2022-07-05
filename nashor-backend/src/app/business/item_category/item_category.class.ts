import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_item_category_create,
	dml_item_category_delete,
	dml_item_category_update,
	view_item_category_by_company_query_read,
	view_item_category_query_read,
	view_item_category_specific_read,
} from './item_category.store';

export class ItemCategory {
	/** Attributes */
	public id_user_?: number;
	public id_item_category: number;
	public company: Company;
	public name_item_category?: string;
	public description_item_category?: string;
	public deleted_item_category?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_item_category: number = 0,
		company: Company = _company,
		name_item_category: string = '',
		description_item_category: string = '',
		deleted_item_category: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_item_category = id_item_category;
		this.company = company;
		this.name_item_category = name_item_category;
		this.description_item_category = description_item_category;
		this.deleted_item_category = deleted_item_category;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_item_category(id_item_category: number) {
		this.id_item_category = id_item_category;
	}
	get _id_item_category() {
		return this.id_item_category;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_item_category(name_item_category: string) {
		this.name_item_category = name_item_category;
	}
	get _name_item_category() {
		return this.name_item_category!;
	}

	set _description_item_category(description_item_category: string) {
		this.description_item_category = description_item_category;
	}
	get _description_item_category() {
		return this.description_item_category!;
	}

	set _deleted_item_category(deleted_item_category: boolean) {
		this.deleted_item_category = deleted_item_category;
	}
	get _deleted_item_category() {
		return this.deleted_item_category!;
	}

	/** Methods */
	create() {
		return new Promise<ItemCategory>(async (resolve, reject) => {
			await dml_item_category_create(this)
				.then((itemCategorys: ItemCategory[]) => {
					/**
					 * Mutate response
					 */
					const _itemCategorys = this.mutateResponse(itemCategorys);

					resolve(_itemCategorys[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<ItemCategory[]>(async (resolve, reject) => {
			await view_item_category_query_read(this)
				.then((itemCategorys: ItemCategory[]) => {
					/**
					 * Mutate response
					 */
					const _itemCategorys = this.mutateResponse(itemCategorys);

					resolve(_itemCategorys);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<ItemCategory[]>(async (resolve, reject) => {
			await view_item_category_by_company_query_read(this)
				.then((itemCategorys: ItemCategory[]) => {
					/**
					 * Mutate response
					 */
					const _itemCategorys = this.mutateResponse(itemCategorys);

					resolve(_itemCategorys);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<ItemCategory>(async (resolve, reject) => {
			await view_item_category_specific_read(this)
				.then((itemCategorys: ItemCategory[]) => {
					/**
					 * Mutate response
					 */
					const _itemCategorys = this.mutateResponse(itemCategorys);

					resolve(_itemCategorys[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<ItemCategory>(async (resolve, reject) => {
			await dml_item_category_update(this)
				.then((itemCategorys: ItemCategory[]) => {
					/**
					 * Mutate response
					 */
					const _itemCategorys = this.mutateResponse(itemCategorys);

					resolve(_itemCategorys[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_item_category_delete(this)
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
	 * @param itemCategorys
	 * @returns
	 */
	private mutateResponse(itemCategorys: ItemCategory[]): ItemCategory[] {
		let _itemCategorys: ItemCategory[] = [];

		itemCategorys.map((item: any) => {
			let _itemCategory: ItemCategory | any = {
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

			delete _itemCategory.id_company;
			delete _itemCategory.id_setting;
			delete _itemCategory.name_company;
			delete _itemCategory.acronym_company;
			delete _itemCategory.address_company;
			delete _itemCategory.status_company;

			_itemCategorys.push(_itemCategory);
		});

		return _itemCategorys;
	}
}
