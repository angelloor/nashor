import { routerArea } from '../app/business/area/area.network';
import { routerAttached } from '../app/business/attached/attached.network';
import { routerColumnProcessItem } from '../app/business/column_process_item/column_process_item.network';
import { routerControl } from '../app/business/control/control.network';
import { routerDocumentationProfile } from '../app/business/documentation_profile/documentation_profile.network';
import { routerDocumentationProfileAttached } from '../app/business/documentation_profile/documentation_profile_attached/documentation_profile_attached.network';
import { routerFlow } from '../app/business/flow/flow.network';
import { routerFlowVersion } from '../app/business/flow_version/flow_version.network';
import { routerFlowVersionLevel } from '../app/business/flow_version_level/flow_version_level.network';
import { routerItem } from '../app/business/item/item.network';
import { routerItemCategory } from '../app/business/item_category/item_category.network';
import { routerLevel } from '../app/business/level/level.network';
import { routerLevelProfile } from '../app/business/level_profile/level_profile.network';
import { routerLevelProfileOfficial } from '../app/business/level_profile_official/level_profile_official.network';
import { routerLevelStatus } from '../app/business/level_status/level_status.network';
import { routerOfficial } from '../app/business/official/official.network';
import { routerPluginItem } from '../app/business/plugin_item/plugin_item.network';
import { routerPluginItemColumn } from '../app/business/plugin_item_column/plugin_item_column.network';
import { routerPosition } from '../app/business/position/position.network';
import { routerProcess } from '../app/business/process/process.network';
import { routerProcessAttached } from '../app/business/process_attached/process_attached.network';
import { routerProcessComment } from '../app/business/process_comment/process_comment.network';
import { routerProcessControl } from '../app/business/process_control/process_control.network';
import { routerProcessItem } from '../app/business/process_item/process_item.network';
import { routerTask } from '../app/business/task/task.network';
import { routerTemplate } from '../app/business/template/template.network';
import { routerTemplateControl } from '../app/business/template_control/template_control.network';
import { routerAuth } from '../app/core/auth/auth.network';
import { routerCompany } from '../app/core/company/company.network';
import { routerNavigation } from '../app/core/navigation/navigation.network';
import { routerProfile } from '../app/core/profile/profile.network';
import { routerProfileNavigation } from '../app/core/profile_navigation/profile_navigation.network';
import { routerSession } from '../app/core/session/session.network';
import { routerSystemEvent } from '../app/core/system_event/system_event.network';
import { routerTypeUser } from '../app/core/type_user/type_user.network';
import { routerUser } from '../app/core/user/user.network';
import { routerValidation } from '../app/core/validation/validation.network';
import { routerReport } from '../app/report/report.network';
import { routerDev } from '../dev/dev.network';

export const appRoutes = (app: any) => {
	/**
	 * Core Routes
	 */
	app.use('/app/core/auth', routerAuth);

	app.use('/app/core/company', routerCompany);
	app.use('/app/core/validation', routerValidation);

	app.use('/app/core/navigation', routerNavigation);
	app.use('/app/core/profile', routerProfile);
	app.use('/app/core/type_user', routerTypeUser);
	app.use('/app/core/profile_navigation', routerProfileNavigation);

	app.use('/app/core/user', routerUser);
	app.use('/app/core/session', routerSession);
	app.use('/app/core/system_event', routerSystemEvent);
	/**
	 * Report Route
	 */
	app.use('/app/report', routerReport);
	/**
	 * Dev Routes
	 */
	app.use('/dev', routerDev);
	/**
	 * Business Routes
	 */
	app.use('/app/business/area', routerArea);
	app.use('/app/business/position', routerPosition);
	app.use('/app/business/official', routerOfficial);
	app.use('/app/business/attached', routerAttached);
	app.use('/app/business/documentation_profile', routerDocumentationProfile);
	app.use(
		'/app/business/documentation_profile_attached',
		routerDocumentationProfileAttached
	);
	app.use('/app/business/item_category', routerItemCategory);
	app.use('/app/business/item', routerItem);
	app.use('/app/business/control', routerControl);
	app.use('/app/business/plugin_item', routerPluginItem);
	app.use('/app/business/plugin_item_column', routerPluginItemColumn);
	app.use('/app/business/template', routerTemplate);
	app.use('/app/business/template_control', routerTemplateControl);
	app.use('/app/business/flow', routerFlow);
	app.use('/app/business/level_status', routerLevelStatus);
	app.use('/app/business/level_profile', routerLevelProfile);
	app.use('/app/business/level_profile_official', routerLevelProfileOfficial);
	app.use('/app/business/level', routerLevel);
	app.use('/app/business/flow_version', routerFlowVersion);
	app.use('/app/business/flow_version_level', routerFlowVersionLevel);
	app.use('/app/business/process', routerProcess);
	app.use('/app/business/task', routerTask);
	app.use('/app/business/process_item', routerProcessItem);
	app.use('/app/business/column_process_item', routerColumnProcessItem);
	app.use('/app/business/process_attached', routerProcessAttached);
	app.use('/app/business/process_control', routerProcessControl);
	app.use('/app/business/process_comment', routerProcessComment);
};
