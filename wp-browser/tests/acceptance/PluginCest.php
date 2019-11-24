<?php

class PluginCest
{
    public function _before(AcceptanceTester $I)
    {
        $I->loginAsAdmin();
        $I->amOnPluginsPage();
    }

    public function _after(AcceptanceTester $I)
    {
        // needed in order to continue browsing the WordPress locally
        // otherwise a wrong value for sitehome/url is used
        $I->cli("search-replace 'localhost' 'localhost:8080' --skip-columns=guid");
    }

    public function seePlugin(AcceptanceTester $I)
    {
        $I->see('My Plugin');
    }

    public function activatePlugin(AcceptanceTester $I)
    {
        $I->activatePlugin('my-plugin');

        $I->see('Selected plugins activated');
        $I->see('Deactivate');
    }
}
