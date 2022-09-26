import { company } from 'app/modules/core/company/company.data';
import { documentationProfile } from '../documentation-profile/documentation-profile.data';
import { pluginItem } from '../plugin-item/plugin-item.data';
import { Template } from './template.types';

export const templates: Template[] = [];
export const template: Template = {
  id_template: ' ',
  company: company,
  documentation_profile: documentationProfile,
  plugin_item: pluginItem,
  plugin_attached_process: false,
  plugin_item_process: false,
  name_template: ' ',
  description_template: ' ',
  status_template: false,
  last_change: ' ',
  in_use: false,
  deleted_template: false,
};
