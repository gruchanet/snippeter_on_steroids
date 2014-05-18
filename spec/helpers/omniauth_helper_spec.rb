require 'spec_helper'

# Authentication helper, to simulate github connection
OmniAuth.config.test_mode = true
omniauth_hash = {
    'provider' => 'github',
    'uid' => '12345',
    'info' => {
        'name' => 'Chuck the Tester',
        'email' => 'chuck@test.it',
        'nickname' => 'chuck_tester'
    },
    'extra' => {
        'raw_info' =>
            {
                'location' => 'Testerro',
                'gravatar_id' => '500100900'
            }
    }
}

OmniAuth.config.add_mock(:github, omniauth_hash)