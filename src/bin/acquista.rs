////////////////////////////////////////////////////////////////////////////////////////////////////

// library wrapper
use ds_legno::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::utils::sql::*;
use crate::utils::xml_parser::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// DOC: first argument will be used as input
// DOC: check whether invoice number exists prior to inserting

////////////////////////////////////////////////////////////////////////////////////////////////////

fn main() {
	// get path
	let file_path = std::env::args_os().nth(1)?;
	let file = File::open(file_path)?;

	// parse file
	let fattura_to_capture = xml_parser(file)?;

	// open database connection
	let mut conn = establish_db_connection()?;

	// prepare data to upload
	let fatture_to_upload = fattura_to_capture.upload_formatter()?;

	// upload to database
	for fattura_to_upload in fatture_to_upload.into_iter() {
		let _ = insert_insertable_struct(fattura_to_upload, &mut conn)?;
	}

	Ok(())
}

////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// #![allow(non_snake_case)]

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// use dioxus::prelude::*;

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// use chrono::{DateTime, Utc};
// use serde::{Deserialize, Serialize};

// fn main() {
// 	launch(App);
// }

// pub fn App() -> Element {
// 	rsx! {
// 		StoryListing {
// 			story: StoryItem {
// 				id: 0,
// 				title: "hello hackernews".to_string(),
// 				url: None,
// 				text: None,
// 				by: "Author".to_string(),
// 				score: 0,
// 				descendants: 0,
// 				time: chrono::Utc::now(),
// 				kids: vec![],
// 				r#type: "".to_string(),
// 			}
// 		}
// 	}
// }

// // Define the Hackernews types
// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct StoryPageData {
// 	#[serde(flatten)]
// 	pub item: StoryItem,
// 	#[serde(default)]
// 	pub comments: Vec<Comment>,
// }

// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct Comment {
// 	pub id: i64,
// 	/// there will be no by field if the comment was deleted
// 	#[serde(default)]
// 	pub by: String,
// 	#[serde(default)]
// 	pub text: String,
// 	#[serde(with = "chrono::serde::ts_seconds")]
// 	pub time: DateTime<Utc>,
// 	#[serde(default)]
// 	pub kids: Vec<i64>,
// 	#[serde(default)]
// 	pub sub_comments: Vec<Comment>,
// 	pub r#type: String,
// }

// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct StoryItem {
// 	pub id: i64,
// 	pub title: String,
// 	pub url: Option<String>,
// 	pub text: Option<String>,
// 	#[serde(default)]
// 	pub by: String,
// 	#[serde(default)]
// 	pub score: i64,
// 	#[serde(default)]
// 	pub descendants: i64,
// 	#[serde(with = "chrono::serde::ts_seconds")]
// 	pub time: DateTime<Utc>,
// 	#[serde(default)]
// 	pub kids: Vec<i64>,
// 	pub r#type: String,
// }

// #[component]
// fn StoryListing(story: ReadOnlySignal<StoryItem>) -> Element {
// 	let StoryItem {
// 		title,
// 		url,
// 		by,
// 		score,
// 		time,
// 		kids,
// 		..
// 	} = &*story.read();

// 	let url = url.as_deref().unwrap_or_default();
// 	let hostname = url
// 		.trim_start_matches("https://")
// 		.trim_start_matches("http://")
// 		.trim_start_matches("www.");
// 	let score = format!("{score} {}", if *score == 1 { " point" } else { " points" });
// 	let comments = format!(
// 		"{} {}",
// 		kids.len(),
// 		if kids.len() == 1 {
// 			" comment"
// 		} else {
// 			" comments"
// 		}
// 	);
// 	let time = time.format("%D %l:%M %p");

// 	rsx! {
// 		div { padding: "0.5rem", position: "relative",
// 			div { font_size: "1.5rem",
// 				a { href: url, "{title}" }
// 				a {
// 					color: "gray",
// 					href: "https://news.ycombinator.com/from?site={hostname}",
// 					text_decoration: "none",
// 					" ({hostname})"
// 				}
// 			}
// 			div { display: "flex", flex_direction: "row", color: "gray",
// 				div { "{score}" }
// 				div { padding_left: "0.5rem", "by {by}" }
// 				div { padding_left: "0.5rem", "{time}" }
// 				div { padding_left: "0.5rem", "{comments}" }
//             }
//         }
//     }
// }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////
