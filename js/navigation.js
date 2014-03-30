;(function($) {
    var Navigation = function() {

        self._init = function() {
            self._bindListeners();
        };

        self._bindListeners = function() {
            var objectRef = this;
            $('a').each(function() {
                var $element = $(this),
                    href = $element.attr('href');

                if (href.indexOf('#') === 0) {
                    var targetAnchor = href.replace('#', '');
                    $element.bind('click', function() {
                        return objectRef._onClick(targetAnchor);
                    })
                }

            });
        };

        self._onClick = function(targetAnchor) {
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

        self._init();
    };

    $(document).ready(function() {
        new Navigation();
    });

})($);