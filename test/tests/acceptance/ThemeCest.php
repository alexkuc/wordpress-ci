<?php

class ThemeCest
{
    public function _before(AcceptanceTester $I)
    {
        $I->loginAsAdmin();
        $I->amOnAdminPage('/themes.php');
    }

    public function seeTheme(AcceptanceTester $I)
    {
        $I->see('My Theme');
    }

    public function activateTheme(AcceptanceTester $I)
    {
        $I->click('Activate');

        $I->see('New theme activated');
        $I->see('Active: My Theme');
    }

    public function seeHomePage(AcceptanceTester $I)
    {
        $url = getenv('TEST_SITE_WP_URL');
        $I->amOnPage($url);

        $I->see('Just another WordPress site');
        $I->see('Hello world!');
    }
}
