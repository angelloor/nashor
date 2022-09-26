import { Control } from '../control/control.class';
import { _control } from '../control/control.data';
import { Template } from '../template/template.class';
import { _template } from '../template/template.data';
import {
	dml_template_control_create,
	dml_template_control_create_with_new_control,
	dml_template_control_delete,
	dml_template_control_update_control_properties,
	dml_template_control_update_positions,
	view_template_control_by_control_read,
	view_template_control_by_template_read,
	view_template_control_specific_read,
} from './template_control.store';

export class TemplateControl {
	/** Attributes */
	public id_user_?: number;
	public id_template_control: number;
	public template: Template;
	public control: Control;
	public ordinal_position?: number;

	public template_control?: TemplateControl[];
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_template_control: number = 0,
		template: Template = _template,
		control: Control = _control,
		ordinal_position: number = 0
	) {
		this.id_user_ = id_user_;
		this.id_template_control = id_template_control;
		this.template = template;
		this.control = control;
		this.ordinal_position = ordinal_position;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_template_control(id_template_control: number) {
		this.id_template_control = id_template_control;
	}
	get _id_template_control() {
		return this.id_template_control;
	}

	set _template(template: Template) {
		this.template = template;
	}
	get _template() {
		return this.template;
	}

	set _control(control: Control) {
		this.control = control;
	}
	get _control() {
		return this.control;
	}

	set _ordinal_position(ordinal_position: number) {
		this.ordinal_position = ordinal_position;
	}
	get _ordinal_position() {
		return this.ordinal_position!;
	}

	/** Methods */
	create() {
		return new Promise<TemplateControl>(async (resolve, reject) => {
			await dml_template_control_create(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	createWithNewControl() {
		return new Promise<TemplateControl>(async (resolve, reject) => {
			await dml_template_control_create_with_new_control(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byTemplateRead() {
		return new Promise<TemplateControl[]>(async (resolve, reject) => {
			await view_template_control_by_template_read(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byControlRead() {
		return new Promise<TemplateControl[]>(async (resolve, reject) => {
			await view_template_control_by_control_read(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<TemplateControl>(async (resolve, reject) => {
			await view_template_control_specific_read(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	updateControlProperties() {
		return new Promise<TemplateControl>(async (resolve, reject) => {
			await dml_template_control_update_control_properties(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	updatePositions() {
		return new Promise<TemplateControl[]>(async (resolve, reject) => {
			await dml_template_control_update_positions(this)
				.then((templateControls: TemplateControl[]) => {
					/**
					 * Mutate response
					 */
					const _templateControls = this.mutateResponse(templateControls);

					resolve(_templateControls);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_template_control_delete(this)
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
	 * @param templateControls
	 * @returns
	 */
	private mutateResponse(
		templateControls: TemplateControl[]
	): TemplateControl[] {
		let _templateControls: TemplateControl[] = [];

		templateControls.map((item: any) => {
			let _templateControl: TemplateControl | any = {
				...item,
				template: {
					id_template: item.id_template,
					company: { id_company: item.id_company },
					documentation_profile: {
						id_documentation_profile: item.id_documentation_profile,
					},
					plugin_item: {
						id_plugin_item: item.id_plugin_item,
					},
					plugin_attached_process: item.plugin_attached_process,
					plugin_item_process: item.plugin_item_process,
					name_template: item.name_template,
					description_template: item.description_template,
					status_template: item.status_template,
					last_change: item.last_change,
				},
				control: {
					id_control: item.id_control,
					company: { id_company: item.id_company },
					type_control: item.type_control,
					title_control: item.title_control,
					form_name_control: item.form_name_control,
					initial_value_control: item.initial_value_control,
					required_control: item.required_control,
					min_length_control: item.min_length_control,
					max_length_control: item.max_length_control,
					placeholder_control: item.placeholder_control,
					spell_check_control: item.spell_check_control,
					options_control: item.options_control,
					in_use: item.in_use,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _templateControl.id_template;
			delete _templateControl.id_company;
			delete _templateControl.id_documentation_profile;
			delete _templateControl.id_plugin_item;
			delete _templateControl.plugin_attached_process;
			delete _templateControl.plugin_item_process;
			delete _templateControl.name_template;
			delete _templateControl.description_template;
			delete _templateControl.status_template;
			delete _templateControl.last_change;
			delete _templateControl.in_use;
			delete _templateControl.id_control;
			delete _templateControl.id_company;
			delete _templateControl.type_control;
			delete _templateControl.title_control;
			delete _templateControl.form_name_control;
			delete _templateControl.initial_value_control;
			delete _templateControl.required_control;
			delete _templateControl.min_length_control;
			delete _templateControl.max_length_control;
			delete _templateControl.placeholder_control;
			delete _templateControl.spell_check_control;
			delete _templateControl.options_control;
			delete _templateControl.in_use;

			_templateControls.push(_templateControl);
		});

		return _templateControls;
	}
}
