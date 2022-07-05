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
	public is_level?: boolean;
	public is_go?: boolean;
	public is_finish?: boolean;
	public is_conditional?: boolean;
	public type_conditional?: TYPE_CONDITIONAL;
	public expression?: string;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_flow_version_level: number = 0,
		flow_version: FlowVersion = _flowVersion,
		level: Level = _level,
		position_level: number = 0,
		is_level: boolean = false,
		is_go: boolean = false,
		is_finish: boolean = false,
		is_conditional: boolean = false,
		type_conditional: TYPE_CONDITIONAL = 'if',
		expression: string = ''
	) {
		this.id_user_ = id_user_;
		this.id_flow_version_level = id_flow_version_level;
		this.flow_version = flow_version;
		this.level = level;
		this.position_level = position_level;
		this.is_level = is_level;
		this.is_go = is_go;
		this.is_finish = is_finish;
		this.is_conditional = is_conditional;
		this.type_conditional = type_conditional;
		this.expression = expression;
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

	set _is_level(is_level: boolean) {
		this.is_level = is_level;
	}
	get _is_level() {
		return this.is_level!;
	}

	set _is_go(is_go: boolean) {
		this.is_go = is_go;
	}
	get _is_go() {
		return this.is_go!;
	}

	set _is_finish(is_finish: boolean) {
		this.is_finish = is_finish;
	}
	get _is_finish() {
		return this.is_finish!;
	}

	set _is_conditional(is_conditional: boolean) {
		this.is_conditional = is_conditional;
	}
	get _is_conditional() {
		return this.is_conditional!;
	}

	set _type_conditional(type_conditional: TYPE_CONDITIONAL) {
		this.type_conditional = type_conditional;
	}
	get _type_conditional() {
		return this.type_conditional!;
	}

	set _expression(expression: string) {
		this.expression = expression;
	}
	get _expression() {
		return this.expression!;
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
 * Type Enum TYPE_CONDITIONAL
 */
export type TYPE_CONDITIONAL = 'if' | 'switch';

export interface TYPE_CONDITIONAL_ENUM {
	name_type: string;
	value_type: TYPE_CONDITIONAL;
}

export const _typeConditional: TYPE_CONDITIONAL_ENUM[] = [
	{
		name_type: 'IF',
		value_type: 'if',
	},
	{
		name_type: 'SWITCH',
		value_type: 'switch',
	},
];

export const validationTypeConditional = (
	attribute: string,
	value: string | TYPE_CONDITIONAL
) => {
	return new Promise<Boolean>((resolve, reject) => {
		const typeConditional = _typeConditional.find(
			(typeConditional: TYPE_CONDITIONAL_ENUM) =>
				typeConditional.value_type == value
		);

		if (!typeConditional) {
			reject({
				..._messages[7],
				description: _messages[7].description
					.replace('_nameAttribute', `${attribute}`)
					.replace('_expectedType', 'TYPE_CONDITIONAL'),
			});
		}
	});
};

/**
 * Type Enum TYPE_CONDITIONAL
 */
