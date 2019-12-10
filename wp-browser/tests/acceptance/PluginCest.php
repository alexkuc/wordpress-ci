<?php

class PluginCest
{
    public function _before(AcceptanceTester $I)
    {
        $I->loginAsAdmin();
        $I->amOnPluginsPage();
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
