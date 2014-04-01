;(function($) {
    var Navigation = function() {

        this._init = function() {
            this._bindListeners();

            this._scrollEventStackSize = 0;
            this._scrollHandlingDelay = 300;
        };

        this._bindListeners = function() {
            var objectRef = this;
            $('a').each(function() {
                var $element = $(this),
                    href = $element.attr('href');

                if (href.indexOf('#') === 0) {
                    var targetAnchor = href.replace('#', '');
                    $element.bind('click', function() {
                        return objectRef._onClick(targetAnchor);
                    });
                }

            });

            $(window).bind('scroll', function() {
                objectRef._onScroll();
            });
        };

        this._onClick = function(targetAnchor) {
            var $targetElement = $('#' + targetAnchor);
            $('html,body').animate(
                {scrollTop: $targetElement.offset().top},
                'slow',
                undefined,
                function() {
                    window.location.hash = targetAnchor;
                });
            return false;
        };

        this._onScroll = function() {
            var objectRef = this;
            this._scrollEventStackSize += 1;
            setTimeout(function() {
                objectRef._scrollEventStackSize -= 1;
                if (objectRef._scrollEventStackSize === 0) {
                    objectRef._updateHashFromScroll();
                }
            }, objectRef._scrollHandlingDelay);
        };

        this._updateHashFromScroll = function() {
            var currentScroll = window.pageYOffset + 200,
                $closestBlock = this._getClosestUpperBlock(currentScroll);

            if (typeof($closestBlock) === 'undefined') {
                window.location.hash = '';
                return;
            }

            var blockId = $closestBlock.attr('id');
            $closestBlock.attr('id', '');
            window.location.hash = blockId;
            $closestBlock.attr('id', blockId);
        };

        this._getClosestUpperBlock = function(currentScroll) {
            var $closestBlock = undefined,
                closestOffsetDelta = undefined;

            $('.content-block').each(function() {
                var $element = $(this),
                    currentOffset = $element.offset().top,
                    currentDelta = currentScroll - currentOffset;

                if ((currentDelta > 0) &&
                    ((typeof($closestBlock) === 'undefined')
                        || (currentDelta < closestOffsetDelta))) {
                    $closestBlock = $element;
                    closestOffsetDelta = currentDelta;
                }
            });

            return $closestBlock;
        };

        this._init();
    };

    $(document).ready(function() {
        new Navigation();
    });

})($);