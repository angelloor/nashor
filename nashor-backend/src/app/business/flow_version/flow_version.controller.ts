import { checkDateString, FullDate } from '../../../utils/date';
import { verifyToken } from '../../../utils/jwt';
import { _messages } from '../../../utils/message/message';
import { FlowVersion } from './flow_version.class';

export const validation = (
	flow_version: FlowVersion,
	url: string,
	token: string
) => {
	return new Promise<FlowVersion | FlowVersion[] | boolean | any>(
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
								flow_version.id_user_,
								'number',
								10
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'id_flow_version',
								flow_version.id_flow_version,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'number_flow_version',
								flow_version.number_flow_version,
								'number',
								5
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'status_flow_version',
								flow_version.status_flow_version,
								'boolean'
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});
						}

						if (url == '/update') {
							attributeValidate(
								'creation_date_flow_version',
								flow_version.creation_date_flow_version,
								'string',
								30
							).catch((err) => {
								validationStatus = true;
								reject(err);
							});

							/**
							 * checkDateString
							 */
							await checkDateString(flow_version.creation_date_flow_version!)
								.then((fullDate: FullDate) => {
									flow_version.creation_date_flow_version = `${fullDate.fullYear}-${fullDate.month}-${fullDate.day} ${fullDate.hours}:${fullDate.minutes}:${fullDate.seconds}.${fullDate.milliSeconds}`;
								})
								.catch(() => {
									validationStatus = true;
									reject({
										..._messages[12],
										description: _messages[12].description.replace(
											'value_date',
											flow_version.creation_date_flow_version!
										),
									});
								});
						}

						/**
						 * Validation flow
						 */

						if (url == '/create' || url == '/update') {
							attributeValidate(
								'id_flow',
								flow_version.flow.id_flow,
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
							const _flow_version = new FlowVersion();
							/**
							 * Execute the url depending on the path
							 */
							if (url == '/create') {
								/** set required attributes for action */
								_flow_version.id_user_ = flow_version.id_user_;
								_flow_version.flow = flow_version.flow;
								await _flow_version
									.create()
									.then((_flowVersion: FlowVersion) => {
										resolve(_flowVersion);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 11) == '/byFlowRead') {
								const id_flow: any = flow_version.flow;

								if (id_flow >= 1) {
									/** set required attributes for action */
									_flow_version.flow = flow_version.flow;
									await _flow_version
										.byFlowRead()
										.then((_flow_versions: FlowVersion[]) => {
											resolve(_flow_versions);
										})
										.catch((error: any) => {
											reject(error);
										});
								} else {
									reject({
										..._messages[11],
										description: _messages[11].description.replace(
											'name_entity',
											'flow'
										),
									});
								}
							} else if (url.substring(0, 13) == '/specificRead') {
								const id_flow_version: any = flow_version.id_flow_version;

								if (id_flow_version >= 1) {
									/** set required attributes for action */
									_flow_version.id_flow_version = flow_version.id_flow_version;
									await _flow_version
										.specificRead()
										.then((_flowVersion: FlowVersion) => {
											resolve(_flowVersion);
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
							} else if (url == '/update') {
								/** set required attributes for action */
								_flow_version.id_user_ = flow_version.id_user_;
								_flow_version.id_flow_version = flow_version.id_flow_version;
								_flow_version.flow = flow_version.flow;
								_flow_version.number_flow_version =
									flow_version.number_flow_version;
								_flow_version.status_flow_version =
									flow_version.status_flow_version;
								_flow_version.creation_date_flow_version =
									flow_version.creation_date_flow_version;
								await _flow_version
									.update()
									.then((_flowVersion: FlowVersion) => {
										resolve(_flowVersion);
									})
									.catch((error: any) => {
										reject(error);
									});
							} else if (url.substring(0, 7) == '/delete') {
								/** set required attributes for action */
								_flow_version.id_user_ = flow_version.id_user_;
								_flow_version.id_flow_version = flow_version.id_flow_version;
								await _flow_version
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
