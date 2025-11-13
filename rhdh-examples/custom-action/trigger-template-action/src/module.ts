import { createBackendModule } from '@backstage/backend-plugin-api';
import { scaffolderActionsExtensionPoint } from '@backstage/plugin-scaffolder-node';
import { createTriggerTemplateAction } from './triggerTemplate';

/**
 * Backend module for the custom trigger-template scaffolder action
 */
export const scaffolderModuleTriggerTemplate = createBackendModule({
  pluginId: 'scaffolder',
  moduleId: 'trigger-template',
  register(env) {
    env.registerInit({
      deps: {
        scaffolder: scaffolderActionsExtensionPoint,
      },
      async init({ scaffolder }) {
        // Register the custom action
        scaffolder.addActions(createTriggerTemplateAction());
      },
    });
  },
});
