<?php

class ThemeCest
{
    public function _before(AcceptanceTester $I)
    {
        $I->loginAsAdmin();
        $I->amOnAdminPage('/themes.php');
    }

    public function _after(AcceptanceTester $I)
    {
        // needed in order to continue browsing the WordPress locally
        // otherwise a wrong value for sitehome/url is used
        $I->cli("search-replace 'localhost' 'localhost:8080' --skip-columns=guid");
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
