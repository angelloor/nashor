import { Company } from 'app/modules/core/company/company.types';

export interface PluginItem {
  id_plugin_item: string;
  company: Company;
  name_plugin_item: string;
  description_plugin_item: string;
}
