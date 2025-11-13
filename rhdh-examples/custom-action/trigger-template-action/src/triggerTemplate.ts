import { createTemplateAction } from '@backstage/plugin-scaffolder-node';
import { CatalogClient } from '@backstage/catalog-client';
import fetch from 'node-fetch';

/**
 * Custom scaffolder action to trigger another template
 * This allows Template 1 to trigger Template 2 during execution
 */
export const createTriggerTemplateAction = () => {
  return createTemplateAction<{
    templateRef: string;
    values: Record<string, any>;
    token?: string;
  }>({
    id: 'trigger:template',
    description: 'Triggers another Backstage template with provided values',
    schema: {
      input: {
        type: 'object',
        required: ['templateRef', 'values'],
        properties: {
          templateRef: {
            type: 'string',
            title: 'Template Reference',
            description: 'The entity reference of the template to trigger (e.g., template:default/my-template)',
          },
          values: {
            type: 'object',
            title: 'Template Values',
            description: 'Input values to pass to the triggered template',
          },
          token: {
            type: 'string',
            title: 'Authentication Token',
            description: 'Optional authentication token for API calls',
          },
        },
      },
      output: {
        type: 'object',
        properties: {
          taskId: {
            type: 'string',
            title: 'Task ID',
            description: 'The ID of the triggered scaffolder task',
          },
          taskUrl: {
            type: 'string',
            title: 'Task URL',
            description: 'URL to monitor the triggered task',
          },
        },
      },
    },
    
    async handler(ctx) {
      const { templateRef, values, token } = ctx.input;
      
      ctx.logger.info(`Triggering template: ${templateRef}`);
      ctx.logger.info(`Input values: ${JSON.stringify(values, null, 2)}`);
      
      try {
        // Get the backend URL from config
        const backendUrl = ctx.secrets?.backendUrl || 'http://localhost:7007';
        
        // Parse template reference
        const [kind, namespace, name] = templateRef.split(/[:/]/);
        
        // Construct the scaffolder API endpoint
        const scaffolderApiUrl = `${backendUrl}/api/scaffolder/v2/tasks`;
        
        // Prepare the request payload
        const payload = {
          templateRef: templateRef,
          values: values,
        };
        
        ctx.logger.info(`Calling scaffolder API: ${scaffolderApiUrl}`);
        
        // Make API call to trigger the template
        const headers: Record<string, string> = {
          'Content-Type': 'application/json',
        };
        
        if (token) {
          headers['Authorization'] = `Bearer ${token}`;
        }
        
        const response = await fetch(scaffolderApiUrl, {
          method: 'POST',
          headers: headers,
          body: JSON.stringify(payload),
        });
        
        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(
            `Failed to trigger template: ${response.status} ${response.statusText} - ${errorText}`
          );
        }
        
        const result = await response.json();
        const taskId = result.id;
        const taskUrl = `${backendUrl}/api/scaffolder/v2/tasks/${taskId}`;
        
        ctx.logger.info(`Template triggered successfully! Task ID: ${taskId}`);
        ctx.logger.info(`Task URL: ${taskUrl}`);
        
        // Output the task information
        ctx.output('taskId', taskId);
        ctx.output('taskUrl', taskUrl);
        
      } catch (error) {
        ctx.logger.error(`Error triggering template: ${error}`);
        throw error;
      }
    },
  });
};
