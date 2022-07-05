import { Company } from '../../core/company/company.class';
import { _company } from '../../core/company/company.data';
import {
	dml_position_create,
	dml_position_delete,
	dml_position_update,
	view_position_by_company_query_read,
	view_position_query_read,
	view_position_specific_read,
} from './position.store';

export class Position {
	/** Attributes */
	public id_user_?: number;
	public id_position: number;
	public company: Company;
	public name_position?: string;
	public description_position?: string;
	public deleted_position?: boolean;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_position: number = 0,
		company: Company = _company,
		name_position: string = '',
		description_position: string = '',
		deleted_position: boolean = false
	) {
		this.id_user_ = id_user_;
		this.id_position = id_position;
		this.company = company;
		this.name_position = name_position;
		this.description_position = description_position;
		this.deleted_position = deleted_position;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_position(id_position: number) {
		this.id_position = id_position;
	}
	get _id_position() {
		return this.id_position;
	}

	set _company(company: Company) {
		this.company = company;
	}
	get _company() {
		return this.company;
	}

	set _name_position(name_position: string) {
		this.name_position = name_position;
	}
	get _name_position() {
		return this.name_position!;
	}

	set _description_position(description_position: string) {
		this.description_position = description_position;
	}
	get _description_position() {
		return this.description_position!;
	}

	set _deleted_position(deleted_position: boolean) {
		this.deleted_position = deleted_position;
	}
	get _deleted_position() {
		return this.deleted_position!;
	}

	/** Methods */
	create() {
		return new Promise<Position>(async (resolve, reject) => {
			await dml_position_create(this)
				.then((positions: Position[]) => {
					/**
					 * Mutate response
					 */
					const _positions = this.mutateResponse(positions);

					resolve(_positions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	queryRead() {
		return new Promise<Position[]>(async (resolve, reject) => {
			await view_position_query_read(this)
				.then((positions: Position[]) => {
					/**
					 * Mutate response
					 */
					const _positions = this.mutateResponse(positions);

					resolve(_positions);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	byCompanyQueryRead() {
		return new Promise<Position[]>(async (resolve, reject) => {
			await view_position_by_company_query_read(this)
				.then((positions: Position[]) => {
					/**
					 * Mutate response
					 */
					const _positions = this.mutateResponse(positions);

					resolve(_positions);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	specificRead() {
		return new Promise<Position>(async (resolve, reject) => {
			await view_position_specific_read(this)
				.then((positions: Position[]) => {
					/**
					 * Mutate response
					 */
					const _positions = this.mutateResponse(positions);

					resolve(_positions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	update() {
		return new Promise<Position>(async (resolve, reject) => {
			await dml_position_update(this)
				.then((positions: Position[]) => {
					/**
					 * Mutate response
					 */
					const _positions = this.mutateResponse(positions);

					resolve(_positions[0]);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_position_delete(this)
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
	 * @param positions
	 * @returns
	 */
	private mutateResponse(positions: Position[]): Position[] {
		let _positions: Position[] = [];

		positions.map((item: any) => {
			let _position: Position | any = {
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

			delete _position.id_company;
			delete _position.id_setting;
			delete _position.name_company;
			delete _position.acronym_company;
			delete _position.address_company;
			delete _position.status_company;

			_positions.push(_position);
		});

		return _positions;
	}
}
