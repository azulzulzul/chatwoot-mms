import { frontendURL } from '../../../../helper/URLHelper';
import SettingsWrapper from '../SettingsWrapper.vue';
import BreakSettings from './Index.vue';

export default {
  routes: [
    {
      path: frontendURL('accounts/:accountId/settings/break'),
      component: SettingsWrapper,
      children: [
        { path: '', redirect: to => ({ name: 'break_settings', params: to.params }) },
        {
          path: 'list',
          name: 'break_settings',
          component: BreakSettings,
          meta: { permissions: ['administrator'] },
        },
      ],
    },
  ],
};
