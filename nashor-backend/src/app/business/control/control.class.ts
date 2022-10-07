import { _messages } from '../../../utils/message/message';
import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_control_delete,
	dml_control_delete_cascade,
	dml_control_update,
	view_control_by_company_query_read,
	view_control_by_position_level_read,
	view_control_query_read,
	view_control_specific_read,
} from './control.store';

export class Control {
	/** Attributes */
	public id_user_?: number;
	public id_control: number;
	public company: Company;
	public type_control?: TYPE_CONTROL;
	public title_control?: string;
	public form_name_control?: string;
	public initial_value_control?: string;
	public required_control?: boolean;
	public min_length_control?: number;
	public max_length_control?: number;
	public placeholder_control?: string;
	public spell_check_control?: boolean;
	public options_control?: string;
	public in_use?: boolean;
	public deleted_control?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_control: number = 0,
		company: Company = _company,
		type_control: TYPE_CONTROL = 'input',
		title_control: string = '',
		form_name_control: string = '',
		initial_value_control: string = '',
		required_control: boolean = false,
		min_length_control: number = 0,
		max_length_control: number = 0,
		placeholder_control: string = '',
		spell_check_control: boolean = false,
		options_control: string = '',
		in_use: boolean = false,
		deleted_control: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_control = id_control;
		this.company = company;
		this.type_control = type_control;
		this.title_control = title_control;
		this.form_name_control = form_name_control;
		this.initial_value_control = initial_value_control;
		this.required_control = required_control;
		this.min_length_control = min_length_control;
		this.max_length_control = max_length_control;
		this.placeholder_control = placeholder_control;
		this.spell_check_control = spell_check_control;
		this.options_control = options_control;
		this.in_use = in_use;
		this.deleted_control = deleted_control;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_control(id_control: number) {
		this.id_control = id_control;
	}
	get _id_control() {
		return this.id_control;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _type_control(type_control: TYPE_CONTROL) {
		this.type_control = type_control;
	}
	get _type_control() {
		return this.type_control!;
	}

	set _title_control(title_control: string) {
		this.title_control = title_control;
	}
	get _title_control() {
		return this.title_control!;
	}

	set _form_name_control(form_name_control: string) {
		this.form_name_control = form_name_control;
	}
	get _form_name_control() {
		return this.form_name_control!;
	}

	set _initial_value_control(initial_value_control: string) {
		this.initial_value_control = initial_value_control;
	}
	get _initial_value_control() {
		return this.initial_value_control!;
	}

	set _required_control(required_control: boolean) {
		this.required_control = required_control;
	}
	get _required_control() {
		return this.required_control!;
	}

	set _min_length_control(min_length_control: number) {
		this.min_length_control = min_length_control;
	}
	get _min_length_control() {
		return this.min_length_control!;
	}

	set _max_length_control(max_length_control: number) {
		this.max_length_control = max_length_control;
	}
	get _max_length_control() {
		return this.max_length_control!;
	}

	set _placeholder_control(placeholder_control: string) {
		this.placeholder_control = placeholder_control;
	}
	get _placeholder_control() {
		return this.placeholder_control!;
	}

	set _spell_check_control(spell_check_control: boolean) {
		this.spell_check_control = spell_check_control;
	}
	get _spell_check_control() {
		return this.spell_check_control!;
	}

	set _options_control(options_control: string) {
		this.options_control = options_control;
	}
	get _options_control() {
		return this.options_control!;
	}

	set _in_use(in_use: boolean) {
		this.in_use = in_use;
	}
	get _in_use() {
		return this.in_use!;
	}

	set _deleted_control(deleted_control: boolean) {
		this.deleted_control = deleted_control;
	}
	get _deleted_control() {
		return this.deleted_control!;
	}

	/** Methods */
	queryRead() {
		return new Promise<Control[]>(async (resolve, reject) => {
			await view_control_query_read(this)
				.then((controls: Control[]) => {
					/**
					 * Mutate response
					 */
					const _controls = this.mutateResponse(controls);

					resolve(_controls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Control[]>(async (resolve, reject) => {
			await view_control_by_company_query_read(this)
				.then((controls: Control[]) => {
					/**
					 * Mutate response
					 */
					const _controls = this.mutateResponse(controls);

					resolve(_controls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byPositionLevel() {
		return new Promise<Control[]>(async (resolve, reject) => {
			await view_control_by_position_level_read(this)
				.then((controls: Control[]) => {
					/**
					 * Mutate response
					 */
					const _controls = this.mutateResponse(controls);

					resolve(_controls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Control>(async (resolve, reject) => {
			await view_control_specific_read(this)
				.then((controls: Control[]) => {
					/**
					 * Mutate response
					 */
					const _controls = this.mutateResponse(controls);

					resolve(_controls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Control>(async (resolve, reject) => {
			await dml_control_update(this)
				.then((controls: Control[]) => {
					/**
					 * Mutate response
					 */
					const _controls = this.mutateResponse(controls);

					resolve(_controls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_control_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	cascadeDelete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_control_delete_cascade(this)
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
	 * @param controls
	 * @returns
	 */
	private mutateResponse(controls: Control[]): Control[] {
		let _controls: Control[] = [];

		controls.map((item: any) => {
			let _control: Control | any = {
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

			delete _control.id_company;
			delete _control.id_setting;
			delete _control.name_company;
			delete _control.acronym_company;
			delete _control.address_company;
			delete _control.status_company;

			_controls.push(_control);
		});

		return _controls;
	}
}

/**
 * Type Enum TYPE_CONTROL
 */
export type TYPE_CONTROL =
	| 'input'
	| 'textArea'
	| 'radioButton'
	| 'checkBox'
	| 'select'
	| 'date'
	| 'dateRange';

export interface TYPE_CONTROL_ENUM {
	name_type: string;
	value_type: TYPE_CONTROL;
}

export const _typeControl: TYPE_CONTROL_ENUM[] = [
	{
		name_type: 'Entrada de texto',
		value_type: 'input',
	},
	{
		name_type: 'Párrafo',
		value_type: 'textArea',
	},
	{
		name_type: 'Opción multiple',
		value_type: 'radioButton',
	},
	{
		name_type: 'Casillas de verificación',
		value_type: 'checkBox',
	},
	{
		name_type: 'Lista desplegable',
		value_type: 'select',
	},
	{
		name_type: 'Fecha',
		value_type: 'date',
	},
	{
		name_type: 'Rango de fechas',
		value_type: 'dateRange',
	},
];

export const validationTypeControl = (
	attribute: string,
	value: string | TYPE_CONTROL
) => {
	return new Promise<Boolean>((resolve, reject) => {
		const typeControl = _typeControl.find(
			(typeControl: TYPE_CONTROL_ENUM) => typeControl.value_type == value
		);

		if (!typeControl) {
			reject({
				..._messages[7],
				description: _messages[7].description
					.replace('_nameAttribute', `${attribute}`)
					.replace('_expectedType', 'TYPE_CONTROL'),
			});
		}
	});
};

/**
 * Type Enum TYPE_CONTROL
 */
