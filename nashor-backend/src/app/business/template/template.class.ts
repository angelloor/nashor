import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import { DocumentationProfile } from '../documentation_profile/documentation_profile.class';
import { _documentationProfile } from '../documentation_profile/documentation_profile.data';
import {
	dml_template_create,
	dml_template_delete,
	dml_template_update,
	view_template_by_company_query_read,
	view_template_by_documentation_profile_query_read,
	view_template_query_read,
	view_template_specific_read,
} from './template.store';

export class Template {
	/** Attributes */
	public id_user_?: number;
	public id_template: number;
	public company: Company;
	public documentation_profile: DocumentationProfile;
	public plugin_item_process?: boolean;
	public plugin_attached_process?: boolean;
	public name_template?: string;
	public description_template?: string;
	public status_template?: boolean;
	public last_change?: string;
	public in_use?: boolean;
	public deleted_template?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_template: number = 0,
		company: Company = _company,
		documentation_profile: DocumentationProfile = _documentationProfile,
		plugin_item_process: boolean = false,
		plugin_attached_process: boolean = false,
		name_template: string = '',
		description_template: string = '',
		status_template: boolean = false,
		last_change: string = '',
		in_use: boolean = false,
		deleted_template: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_template = id_template;
		this.company = company;
		this.documentation_profile = documentation_profile;
		this.plugin_item_process = plugin_item_process;
		this.plugin_attached_process = plugin_attached_process;
		this.name_template = name_template;
		this.description_template = description_template;
		this.status_template = status_template;
		this.last_change = last_change;
		this.in_use = in_use;
		this.deleted_template = deleted_template;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_template(id_template: number) {
		this.id_template = id_template;
	}
	get _id_template() {
		return this.id_template;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _documentation_profile(documentation_profile: DocumentationProfile) {
		this.documentation_profile = documentation_profile;
	}
	get _documentation_profile() {
		return this.documentation_profile;
	}

	set _plugin_item_process(plugin_item_process: boolean) {
		this.plugin_item_process = plugin_item_process;
	}
	get _plugin_item_process() {
		return this.plugin_item_process!;
	}

	set _plugin_attached_process(plugin_attached_process: boolean) {
		this.plugin_attached_process = plugin_attached_process;
	}
	get _plugin_attached_process() {
		return this.plugin_attached_process!;
	}

	set _name_template(name_template: string) {
		this.name_template = name_template;
	}
	get _name_template() {
		return this.name_template!;
	}

	set _description_template(description_template: string) {
		this.description_template = description_template;
	}
	get _description_template() {
		return this.description_template!;
	}

	set _status_template(status_template: boolean) {
		this.status_template = status_template;
	}
	get _status_template() {
		return this.status_template!;
	}

	set _last_change(last_change: string) {
		this.last_change = last_change;
	}
	get _last_change() {
		return this.last_change!;
	}

	set _in_use(in_use: boolean) {
		this.in_use = in_use;
	}
	get _in_use() {
		return this.in_use!;
	}

	set _deleted_template(deleted_template: boolean) {
		this.deleted_template = deleted_template;
	}
	get _deleted_template() {
		return this.deleted_template!;
	}

	/** Methods */
	create() {
		return new Promise<Template>(async (resolve, reject) => {
			await dml_template_create(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Template[]>(async (resolve, reject) => {
			await view_template_query_read(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Template[]>(async (resolve, reject) => {
			await view_template_by_company_query_read(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byDocumentationProfileQueryRead() {
		return new Promise<Template[]>(async (resolve, reject) => {
			await view_template_by_documentation_profile_query_read(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Template>(async (resolve, reject) => {
			await view_template_specific_read(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Template>(async (resolve, reject) => {
			await dml_template_update(this)
				.then((templates: Template[]) => {
					/**
					 * Mutate response
					 */
					const _templates = this.mutateResponse(templates);

					resolve(_templates[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_template_delete(this)
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
	 * @param templates
	 * @returns
	 */
	private mutateResponse(templates: Template[]): Template[] {
		let _templates: Template[] = [];

		templates.map((item: any) => {
			let _template: Template | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				documentation_profile: {
					id_documentation_profile: item.id_documentation_profile,
					company: { id_company: item.id_company },
					name_documentation_profile: item.name_documentation_profile,
					description_documentation_profile:
						item.description_documentation_profile,
					status_documentation_profile: item.status_documentation_profile,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _template.id_company;
			delete _template.id_setting;
			delete _template.name_company;
			delete _template.acronym_company;
			delete _template.address_company;
			delete _template.status_company;
			delete _template.id_documentation_profile;
			delete _template.id_company;
			delete _template.name_documentation_profile;
			delete _template.description_documentation_profile;
			delete _template.status_documentation_profile;

			_templates.push(_template);
		});

		return _templates;
	}
}
