import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import {
	FlowVersionLevel,
	validationTypeElement,
	validationTypeOperator,
} from './flow_version_level.class';

export const validation = (
	flow_version_level: FlowVersionLevel,
	url: string,
	token: string
) => {
	return new Promise<FlowVersionLevel | FlowVersionLevel[] | boolean | any>(
		async (resolve, reject) => {
			/**
			 * Capa de Autentificación con el token
			 */
			let validationStatus: boolean = false;

			if (token) {
				await verifyToken(token)
					.then(async () => {
						/**
						 * Capa de validaciones
						 */
						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_user_',
								flow_version_level.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_flow_version_level',
								flow_version_level.id_flow_version_level,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'position_level',
								flow_version_level.position_level,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'position_level_father',
								flow_version_level.position_level_father,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update' || url == '/create') {
							validationTypeElement(
								'type_element',
								flow_version_level.type_element!
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							validationTypeOperator(
								'operator',
								flow_version_level.operator!
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'value_against',
								flow_version_level.value_against,
								'string',
								250
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'option_true',
								flow_version_level.option_true,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate('x', flow_version_level.x, 'number', 10).catch(
								(err) => {
									validationStatus = true;
									reject(err);
								}
							);
						}

						if (url == '/update') {
							attributeValidate('y', flow_version_level.y, 'number', 10).catch(
								(err) => {
									validationStatus = true;
									reject(err);
								}
							);
						}

						/**
						 * Validation flowVersion
						 */

						if (url == '/update') {
							attributeValidate(
								'id_flow_version',
								flow_version_level.flow_version.id_flow_version,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Validation level
						 */

						if (url == '/update') {
							attributeValidate(
								'id_level',
								flow_version_level.level.id_level,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						/**
						 * Continuar solo si no ocurrio errores en la validación
						 */
						if (!validationStatus) {
							/**
							 * Instance the class
							 */
							const _flow_version_level = new FlowVersionLevel();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_flow_version_level.id_user_ = flow_version_level.id_user_;
								_flow_version_level.flow_version =
									flow_version_level.flow_version;
								_flow_version_level.type_element =
									flow_version_level.type_element;
								await _flow_version_level
									.create()
									.then((_flowVersionLevel: FlowVersionLevel) => {
										resolve(_flowVersionLevel);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 18) == '/byFlowVersionRead') {
								const id_flow_version: any = flow_version_level.flow_version;

								if (id_flow_version >= 1) {
									/** set required attributes for action */
									_flow_version_level.flow_version =
										flow_version_level.flow_version;
									await _flow_version_level
										.byFlowVersionRead()
										.then((_flow_version_levels: FlowVersionLevel[]) => {
											resolve(_flow_version_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'flow_version'
										),
									});
								}
							} else if (
								url.substring(0, 36) == '/byFlowVersionExcludeConditionalRead'
							) {
								const id_flow_version: any = flow_version_level.flow_version;

								if (id_flow_version >= 1) {
									/** set required attributes for action */
									_flow_version_level.flow_version =
										flow_version_level.flow_version;
									await _flow_version_level
										.byFlowVersionExcludeConditionalRead()
										.then((_flow_version_levels: FlowVersionLevel[]) => {
											resolve(_flow_version_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'flow_version'
										),
									});
								}
							} else if (url.substring(0, 12) == '/byLevelRead') {
								const id_level: any = flow_version_level.level;

								if (id_level >= 1) {
									/** set required attributes for action */
									_flow_version_level.level = flow_version_level.level;
									await _flow_version_level
										.byLevelRead()
										.then((_flow_version_levels: FlowVersionLevel[]) => {
											resolve(_flow_version_levels);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'level'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_flow_version_level: any =
									flow_version_level.id_flow_version_level;

								if (id_flow_version_level >= 1) {
									/** set required attributes for action */
									_flow_version_level.id_flow_version_level =
										flow_version_level.id_flow_version_level;
									await _flow_version_level
										.specificRead()
										.then((_flowVersionLevel: FlowVersionLevel) => {
											resolve(_flowVersionLevel);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'flow_version_level'
										),
									});
								}
							} else if (url == '/update') {
								/** set required attributes for action */
								_flow_version_level.id_user_ = flow_version_level.id_user_;
								_flow_version_level.id_flow_version_level =
									flow_version_level.id_flow_version_level;
								_flow_version_level.flow_version =
									flow_version_level.flow_version;
								_flow_version_level.level = flow_version_level.level;
								_flow_version_level.position_level =
									flow_version_level.position_level;
								_flow_version_level.position_level_father =
									flow_version_level.position_level_father;
								_flow_version_level.type_element =
									flow_version_level.type_element;
								_flow_version_level.id_control = flow_version_level.id_control;
								_flow_version_level.operator = flow_version_level.operator;
								_flow_version_level.value_against =
									flow_version_level.value_against;
								_flow_version_level.option_true =
									flow_version_level.option_true;
								_flow_version_level.x = flow_version_level.x;
								_flow_version_level.y = flow_version_level.y;
								await _flow_version_level
									.update()
									.then((_flowVersionLevel: FlowVersionLevel) => {
										resolve(_flowVersionLevel);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url == '/reset') {
								/** set required attributes for action */
								_flow_version_level.id_user_ = flow_version_level.id_user_;
								_flow_version_level.flow_version =
									flow_version_level.flow_version;
								await _flow_version_level
									.reset()
									.then((response: boolean) => {
										resolve(response);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_flow_version_level.id_user_ = flow_version_level.id_user_;
								_flow_version_level.id_flow_version_level =
									flow_version_level.id_flow_version_level;
								await _flow_version_level
									.delete()
									.then((response: boolean) => {
										resolve(response);
									})
									.catch((error: any) => {
										reject(error);
									});
							}
						}
					})
					.catch((error) => {
						reject(error);
					});
			} else {
				reject(_messages[5]);
			}
		}
	);
};

/**
 * Función para validar un campo de acuerdo a los criterios ingresados
 * @param attribute nombre del atributo a validar
 * @param value valor a validar
 * @param type tipo de dato correcto del atributo (string, number, boolean, object)
 * @param _length longitud correcta del atributo
 * @returns true || error
 */
const attributeValidate = (
	attribute: string,
	value: any,
	type: string,
	_length: number = 0
) => {
	return new Promise<Boolean>((resolve, reject) => {
		if (value != undefined || value != null) {
			if (typeof value == `${type}`) {
				if (typeof value == 'string' || typeof value == 'number') {
					if (value.toString().length > _length) {
						reject({
							..._messages[8],
							description: _messages[8].description
								.replace('_nameAttribute', `${attribute}`)
								.replace('_expectedCharacters', `${_length}`),
						});
					} else {
						resolve(true);
					}
				} else {
					resolve(true);
				}
			} else {
				reject({
					..._messages[7],
					description: _messages[7].description
						.replace('_nameAttribute', `${attribute}`)
						.replace('_expectedType', `${type}`),
				});
			}
		} else {
			reject({
				..._messages[6],
				description: _messages[6].description.replace(
					'_nameAttribute',
					`${attribute}`
				),
			});
		}
	});
};
