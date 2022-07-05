export interface BodyBackendGenerate {
	scheme: string;
	entity: string;
	attributeToQuery: string;
	exclude_column_in_external_table: string[];
}

export interface BodyFrontendGenerate {
	scheme: string;
	entity: string;
	nameVisibility: string;
	pathToCreate: string;
	attributeList: AttributeList;
}

export interface AttributeList {
	first: string;
	second: string;
}
