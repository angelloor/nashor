import { attached } from '../../attached/attached.data';
import { documentationProfile } from '../documentation-profile.data';
import { DocumentationProfileAttached } from './documentation-profile-attached.types';

export const documentationProfileAttacheds: DocumentationProfileAttached[] = [];
export const documentationProfileAttached: DocumentationProfileAttached = {
  id_documentation_profile_attached: ' ',
  documentation_profile: documentationProfile,
  attached: attached,
};
