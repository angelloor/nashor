import { company } from 'app/modules/core/company/company.data';
import { itemCategory } from '../item-category/item-category.data';
import { Item } from './item.types';

export const items: Item[] = [];
export const item: Item = {
  id_item: ' ',
  company: company,
  item_category: itemCategory,
  name_item: ' ',
  description_item: ' ',
  deleted_item: false,
};
