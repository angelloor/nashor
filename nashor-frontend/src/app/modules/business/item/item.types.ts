import { Company } from 'app/modules/core/company/company.types';
import { ItemCategory } from '../item-category/item-category.types';

export interface Item {
  id_item: string;
  company: Company;
  item_category: ItemCategory;
  name_item: string;
  description_item: string;
  cpc_item: string;
  deleted_item: boolean;
}
