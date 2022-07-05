import { Company } from 'app/modules/core/company/company.types';

export interface DocumentationProfile {
  id_documentation_profile: string;
  company: Company;
  name_documentation_profile: string;
  description_documentation_profile: string;
  status_documentation_profile: boolean;
  deleted_documentation_profile: boolean;
}
