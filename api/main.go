package main

import (
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/gocolly/colly"
)

func getContrib(username string, date string) uint64 {
	today_block := fmt.Sprintf(".ContributionCalendar-day[data-date=\"%s\"]", date)
	var count uint64 = 0

	c := colly.NewCollector(
		colly.AllowedDomains("github.com"),
	)

	c.OnHTML(today_block, func(e *colly.HTMLElement) {
		var err error
		count, err = strconv.ParseUint(e.Attr("data-count"), 10, 64)
		if err != nil {
			count = 0
		}
	})

	c.Visit(fmt.Sprintf("https://github.com/%s", username))
	return count
}

func main() {
	// 2022-11-13, 2022-01-02
	args := os.Args[1:]
	if len(args) == 0 {
		fmt.Println("invalid")
		os.Exit(1)
	}

	now := time.Now()
	date := now.Format("2006-01-02")
	x := getContrib(args[0], date)
	fmt.Println(x)
}
