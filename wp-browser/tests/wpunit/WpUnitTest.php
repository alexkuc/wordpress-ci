<?php

class WpUnitTest extends \Codeception\TestCase\WPTestCase
{
    /**
     * @var \WpunitTester
     */
    protected $tester;

    public function setUp()
    {
        parent::setUp();
    }

    public function tearDown()
    {
        parent::tearDown();

        // needed in order to continue browsing the WordPress locally
        // otherwise a wrong value for sitehome/url is used
        $this->tester->cli("search-replace 'localhost' 'localhost:8080' --skip-columns=guid");
    }

    public function test_it_works()
    {
        $post = static::factory()->post->create_and_get();

        $this->assertInstanceOf(\WP_Post::class, $post);
    }
}
