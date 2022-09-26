import { Company } from 'app/modules/core/company/company.types';
import { DocumentationProfile } from '../documentation-profile/documentation-profile.types';
import { PluginItem } from '../plugin-item/plugin-item.types';

export interface Template {
  id_template: string;
  company: Company;
  documentation_profile: DocumentationProfile;
  plugin_item: PluginItem;
  plugin_attached_process: boolean;
  plugin_item_process: boolean;
  name_template: string;
  description_template: string;
  status_template: boolean;
  last_change: string;
  in_use: boolean;
  deleted_template: boolean;
}
