<?php

class FunctionalTestCest
{
    public function _after(AcceptanceTester $I)
    {
        // needed in order to continue browsing the WordPress locally
        // otherwise a wrong value for sitehome/url is used
        $I->cli("search-replace 'localhost' 'localhost:8080' --skip-columns=guid");
    }

    // tests
    public function tryToTest(FunctionalTester $I)
    {
    }
}
