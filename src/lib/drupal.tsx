import {DrupalState} from "@gdwc/drupal-state";
import {DrupalJsonApiParams as BaseDrupalJsonApiParams} from "drupal-jsonapi-params";

export const ResourceVersion = process.env.RESOURCE_VERSION || 'latest-version';
export const Drupal = new DrupalState({
    apiBase: process.env.DRUPAL_BASE_URL || '',
    debug: (process.env.ENVIRONMENT || 'production') === 'development',
    noStore: (process.env.ENVIRONMENT || 'production') === 'development',
})
export const DrupalJsonApiParams = () => {
    const DrupalJsonApiParams = new BaseDrupalJsonApiParams();
    DrupalJsonApiParams.addCustomParam({resourceVersion: 'rel:' + process.env.RESOURCE_VERSION});
    return DrupalJsonApiParams
};
