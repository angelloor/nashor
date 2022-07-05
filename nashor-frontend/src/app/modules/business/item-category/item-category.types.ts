import { Company } from 'app/modules/core/company/company.types';

export interface ItemCategory {
  id_item_category: string;
  company: Company;
  name_item_category: string;
  description_item_category: string;
  deleted_item_category: boolean;
}
