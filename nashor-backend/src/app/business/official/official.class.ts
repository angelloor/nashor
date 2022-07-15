import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import { User } from '../../core/user/user.class';
import { _user } from '../../core/user/user.data';
import { Area } from '../area/area.class';
import { _area } from '../area/area.data';
import { Position } from '../position/position.class';
import { _position } from '../position/position.data';
import {
	dml_official_create,
	dml_official_delete,
	dml_official_update,
	view_official_by_area_query_read,
	view_official_by_company_query_read,
	view_official_by_position_query_read,
	view_official_by_user_read,
	view_official_query_read,
	view_official_specific_read,
} from './official.store';

export class Official {
	/** Attributes */
	public id_user_?: number;
	public id_official: number;
	public company: Company;
	public user: User;
	public area: Area;
	public position: Position;
	public deleted_official?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_official: number = 0,
		company: Company = _company,
		user: User = _user,
		area: Area = _area,
		position: Position = _position,
		deleted_official: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_official = id_official;
		this.company = company;
		this.user = user;
		this.area = area;
		this.position = position;
		this.deleted_official = deleted_official;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_official(id_official: number) {
		this.id_official = id_official;
	}
	get _id_official() {
		return this.id_official;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _user(user: User) {
		this.user = user;
	}
	get _user() {
		return this.user;
	}

	set _area(area: Area) {
		this.area = area;
	}
	get _area() {
		return this.area;
	}

	set _position(position: Position) {
		this.position = position;
	}
	get _position() {
		return this.position;
	}

	set _deleted_official(deleted_official: boolean) {
		this.deleted_official = deleted_official;
	}
	get _deleted_official() {
		return this.deleted_official!;
	}

	/** Methods */
	create() {
		return new Promise<Official>(async (resolve, reject) => {
			await dml_official_create(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Official[]>(async (resolve, reject) => {
			await view_official_query_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Official[]>(async (resolve, reject) => {
			await view_official_by_company_query_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byUserRead() {
		return new Promise<Official>(async (resolve, reject) => {
			await view_official_by_user_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byAreaQueryRead() {
		return new Promise<Official[]>(async (resolve, reject) => {
			await view_official_by_area_query_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byPositionQueryRead() {
		return new Promise<Official[]>(async (resolve, reject) => {
			await view_official_by_position_query_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Official>(async (resolve, reject) => {
			await view_official_specific_read(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Official>(async (resolve, reject) => {
			await dml_official_update(this)
				.then((officials: Official[]) => {
					/**
					 * Mutate response
					 */
					const _officials = this.mutateResponse(officials);

					resolve(_officials[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_official_delete(this)
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
	 * @param officials
	 * @returns
	 */
	private mutateResponse(officials: Official[]): Official[] {
		let _officials: Official[] = [];

		officials.map((item: any) => {
			let _official: Official | any = {
				...item,
				company: {
					id_company: item.id_company,
					setting: { id_setting: item.id_setting },
					name_company: item.name_company,
					acronym_company: item.acronym_company,
					address_company: item.address_company,
					status_company: item.status_company,
				},
				user: {
					id_user: item.id_user,
					company: { id_company: item.id_company },
					person: {
						id_person: item.id_person,
						academic: {
							id_academic: item.id_academic,
							title_academic: item.title_academic,
							abbreviation_academic: item.abbreviation_academic,
							nivel_academic: item.nivel_academic,
						},
						job: {
							id_job: item.id_job,
							name_job: item.name_job,
							address_job: item.address_job,
							phone_job: item.phone_job,
							position_job: item.position_job,
						},
						dni_person: item.dni_person,
						name_person: item.name_person,
						last_name_person: item.last_name_person,
						address_person: item.address_person,
						phone_person: item.phone_person,
					},
					type_user: {
						id_type_user: item.id_type_user,
						company: { id_company: item.id_company },
						profile: { id_profile: item.id_profile },
						name_type_user: item.name_type_user,
						description_type_user: item.description_type_user,
						status_type_user: item.status_type_user,
					},
					name_user: item.name_user,
					password_user: item.password_user,
					avatar_user: item.avatar_user,
					status_user: item.status_user,
				},
				area: {
					id_area: item.id_area,
					company: { id_company: item.id_company },
					name_area: item.name_area,
					description_area: item.description_area,
				},
				position: {
					id_position: item.id_position,
					company: { id_company: item.id_company },
					name_position: item.name_position,
					description_position: item.description_position,
				},
				deleted_official: item.deleted_official,
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _official.id_company;
			delete _official.id_setting;
			delete _official.name_company;
			delete _official.acronym_company;
			delete _official.address_company;
			delete _official.status_company;
			delete _official.id_user;
			delete _official.id_company;
			delete _official.id_person;
			delete _official.id_type_user;
			delete _official.name_user;
			delete _official.password_user;
			delete _official.avatar_user;
			delete _official.status_user;
			delete _official.id_area;
			delete _official.id_company;
			delete _official.name_area;
			delete _official.description_area;
			delete _official.id_position;
			delete _official.id_company;
			delete _official.name_position;
			delete _official.description_position;
			delete _official.deleted_official;

			delete _official.id_academic;
			delete _official.title_academic;
			delete _official.abbreviation_academic;
			delete _official.nivel_academic;
			delete _official.id_job;
			delete _official.name_job;
			delete _official.address_job;
			delete _official.phone_job;
			delete _official.position_job;

			delete _official.dni_person;
			delete _official.name_person;
			delete _official.last_name_person;
			delete _official.address_person;
			delete _official.phone_person;
			delete _official.id_type_user;
			delete _official.id_company;
			delete _official.id_profile;
			delete _official.name_type_user;
			delete _official.description_type_user;
			delete _official.status_type_user;

			_officials.push(_official);
		});

		return _officials;
	}
}
