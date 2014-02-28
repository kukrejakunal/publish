function init_admin_users_page(){
    // Sorting and pagination links.
    $('#users th a, #users .pagination a, #users .per_page_selector a').on('click',
        function () {
//            show_page_loader();
            $.getScript(this.href,function(){
//                hide_page_loader();
            });
            return false;
        }
    );

    // Search
    $('#users_search').submit(function () {
        var search_box = $("#users_search #users_search_text");
        var data = {
            user_type_filter: $.trim($('#users_filter #user_type_filter').val()),
            user_status_filter: $.trim($('#users_filter #user_status_filter').val())
        };
        show_page_loader();
        if ($.trim(search_box.val()).length < 1) {
            search_box.val("");
            fetch_search_and_filter_results(this.action,data);
        }
        else {
            data.search_text = $.trim(search_box.val());
            fetch_search_and_filter_results(this.action,data);
        }
        return false;
    });
}