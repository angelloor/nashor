import { Attached } from '../../attached/attached.types';
import { DocumentationProfile } from '../documentation-profile.types';

export interface DocumentationProfileAttached {
  id_documentation_profile_attached: string;
  documentation_profile: DocumentationProfile;
  attached: Attached;
}
