import { _messages } from '../../../utils/message/message';
import { FlowVersion } from '../flow_version/flow_version.class';
import { _flowVersion } from '../flow_version/flow_version.data';
import { Level } from '../level/level.class';
import { _level } from '../level/level.data';
import {
	dml_flow_version_level_create,
	dml_flow_version_level_delete,
	dml_flow_version_level_reset,
	dml_flow_version_level_update,
	view_flow_version_level_by_flow_version_exclude_conditional_read,
	view_flow_version_level_by_flow_version_read,
	view_flow_version_level_by_level_read,
	view_flow_version_level_specific_read,
} from './flow_version_level.store';

export class FlowVersionLevel {
	/** Attributes */
	public id_user_?: number;
	public id_flow_version_level: number;
	public flow_version: FlowVersion;
	public level: Level;
	public position_level?: number;
	public position_level_father?: number;
	public type_element?: TYPE_ELEMENT;
	public id_control?: string;
	public operator?: TYPE_OPERATOR;
	public value_against?: string;
	public option_true?: boolean;
	public x?: number;
	public y?: number;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_flow_version_level: number = 0,
		flow_version: FlowVersion = _flowVersion,
		level: Level = _level,
		position_level: number = 0,
		position_level_father: number = 0,
		type_element: TYPE_ELEMENT = 'level',
		id_control: string = '',
		operator: TYPE_OPERATOR = '==',
		value_against: string = '',
		option_true: boolean = false,
		x: number = 0,
		y: number = 0
	) {
		this.id_user_ = id_user_;
		this.id_flow_version_level = id_flow_version_level;
		this.flow_version = flow_version;
		this.level = level;
		this.position_level = position_level;
		this.position_level_father = position_level_father;
		this.type_element = type_element;
		this.id_control = id_control;
		this.operator = operator;
		this.value_against = value_against;
		this.option_true = option_true;
		this.x = x;
		this.y = y;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_flow_version_level(id_flow_version_level: number) {
		this.id_flow_version_level = id_flow_version_level;
	}
	get _id_flow_version_level() {
		return this.id_flow_version_level;
	}

	set _flow_version(flow_version: FlowVersion) {
		this.flow_version = flow_version;
	}
	get _flow_version() {
		return this.flow_version;
	}

	set _level(level: Level) {
		this.level = level;
	}
	get _level() {
		return this.level;
	}

	set _position_level(position_level: number) {
		this.position_level = position_level;
	}
	get _position_level() {
		return this.position_level!;
	}

	set _position_level_father(position_level_father: number) {
		this.position_level_father = position_level_father;
	}
	get _position_level_father() {
		return this.position_level_father!;
	}

	set _type_element(type_element: TYPE_ELEMENT) {
		this.type_element = type_element;
	}
	get _type_element() {
		return this.type_element!;
	}

	set _name_control(id_control: string) {
		this.id_control = id_control;
	}
	get _name_control() {
		return this.id_control!;
	}

	set _operator(operator: TYPE_OPERATOR) {
		this.operator = operator;
	}
	get _operator() {
		return this.operator!;
	}

	set _value_against(value_against: string) {
		this.value_against = value_against;
	}
	get _value_against() {
		return this.value_against!;
	}

	set _option_true(option_true: boolean) {
		this.option_true = option_true;
	}
	get _option_true() {
		return this.option_true!;
	}

	set _x(x: number) {
		this.x = x;
	}
	get _x() {
		return this.x!;
	}

	set _y(y: number) {
		this.y = y;
	}
	get _y() {
		return this.y!;
	}

	/** Methods */
	create() {
		return new Promise<FlowVersionLevel>(async (resolve, reject) => {
			await dml_flow_version_level_create(this)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byFlowVersionRead() {
		return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
			await view_flow_version_level_by_flow_version_read(this)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byFlowVersionExcludeConditionalRead() {
		return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
			await view_flow_version_level_by_flow_version_exclude_conditional_read(
				this
			)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byLevelRead() {
		return new Promise<FlowVersionLevel[]>(async (resolve, reject) => {
			await view_flow_version_level_by_level_read(this)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<FlowVersionLevel>(async (resolve, reject) => {
			await view_flow_version_level_specific_read(this)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<FlowVersionLevel>(async (resolve, reject) => {
			await dml_flow_version_level_update(this)
				.then((flowVersionLevels: FlowVersionLevel[]) => {
					/**
					 * Mutate response
					 */
					const _flowVersionLevels = this.mutateResponse(flowVersionLevels);

					resolve(_flowVersionLevels[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	reset() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_flow_version_level_reset(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_flow_version_level_delete(this)
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
	 * @param flowVersionLevels
	 * @returns
	 */
	private mutateResponse(
		flowVersionLevels: FlowVersionLevel[]
	): FlowVersionLevel[] {
		let _flowVersionLevels: FlowVersionLevel[] = [];

		flowVersionLevels.map((item: any) => {
			let _flowVersionLevel: FlowVersionLevel | any = {
				...item,
				flow_version: {
					id_flow_version: item.id_flow_version,
					flow: { id_flow: item.id_flow },
					number_flow_version: item.number_flow_version,
					status_flow_version: item.status_flow_version,
					creation_date_flow_version: item.creation_date_flow_version,
				},
				level: {
					id_level: item.id_level,
					company: { id_company: item.id_company },
					template: { id_template: item.id_template },
					level_profile: { id_level_profile: item.id_level_profile },
					level_status: { id_level_status: item.id_level_status },
					name_level: item.name_level,
					description_level: item.description_level,
				},
				position_level: parseInt(item.position_level),
				position_level_father: parseInt(item.position_level_father),
				x: parseInt(item.x),
				y: parseInt(item.y),
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _flowVersionLevel.id_flow_version;
			delete _flowVersionLevel.id_flow;
			delete _flowVersionLevel.number_flow_version;
			delete _flowVersionLevel.status_flow_version;
			delete _flowVersionLevel.creation_date_flow_version;
			delete _flowVersionLevel.id_level;
			delete _flowVersionLevel.id_company;
			delete _flowVersionLevel.id_template;
			delete _flowVersionLevel.id_level_profile;
			delete _flowVersionLevel.id_level_status;
			delete _flowVersionLevel.name_level;
			delete _flowVersionLevel.description_level;

			_flowVersionLevels.push(_flowVersionLevel);
		});

		return _flowVersionLevels;
	}
}

/**
 * Type Enum TYPE_ELEMENT
 */
export type TYPE_ELEMENT = 'level' | 'conditional' | 'finish';

export interface TYPE_ELEMENT_ENUM {
	name_type: string;
	value_type: TYPE_ELEMENT;
}

export const _typeConditional: TYPE_ELEMENT_ENUM[] = [
	{
		name_type: 'Nivel',
		value_type: 'level',
	},
	{
		name_type: 'Condicional',
		value_type: 'conditional',
	},
	{
		name_type: 'Final',
		value_type: 'finish',
	},
];

export const validationTypeElement = (
	attribute: string,
	value: string | TYPE_ELEMENT
) => {
	return new Promise<Boolean>((resolve, reject) => {
		const typeConditional = _typeConditional.find(
			(typeConditional: TYPE_ELEMENT_ENUM) =>
				typeConditional.value_type == value
		);

		if (!typeConditional) {
			reject({
				..._messages[7],
				description: _messages[7].description
					.replace('_nameAttribute', `${attribute}`)
					.replace('_expectedType', 'TYPE_ELEMENT'),
			});
		}
	});
};

/**
 * Type Enum TYPE_ELEMENT
 */

/**
 * Type Enum TYPE_OPERATOR
 */
export type TYPE_OPERATOR = '==' | '!=' | '<' | '>' | '<=' | '>=';

export interface TYPE_OPERATOR_ENUM {
	name_type: string;
	value_type: TYPE_OPERATOR;
}

export const _typeOperators: TYPE_OPERATOR_ENUM[] = [
	{
		name_type: 'igual',
		value_type: '==',
	},
	{
		name_type: 'Diferente',
		value_type: '!=',
	},
	{
		name_type: 'Menor',
		value_type: '<',
	},
	{
		name_type: 'Mayor',
		value_type: '>',
	},
	{
		name_type: 'Menor que',
		value_type: '<=',
	},
	{
		name_type: 'Mayor que',
		value_type: '>=',
	},
];

export const validationTypeOperator = (
	attribute: string,
	value: string | TYPE_OPERATOR
) => {
	return new Promise<Boolean>((resolve, reject) => {
		const typeOperator = _typeOperators.find(
			(typeOperator: TYPE_OPERATOR_ENUM) => typeOperator.value_type == value
		);

		if (!typeOperator) {
			reject({
				..._messages[7],
				description: _messages[7].description
					.replace('_nameAttribute', `${attribute}`)
					.replace('_expectedType', 'TYPE_OPERATOR'),
			});
		}
	});
};

/**
 * Type Enum TYPE_OPERATOR
 */
