package controllers;

import java.util.List;
import java.util.Random;

import models.Message;
import play.Logger;
import play.mvc.Controller;

public class Messages extends Controller {

	public static void add(Message m) {
		m.save();
	}
	
	public static void since(Long timestamp) {
		List<Message> ms = Message.find("ts > ?", timestamp).fetch();
		if ( ms.size() > 0 ) {
			renderJSON(ms);
		}
		suspend("1s");
	}
	
	public static void list() {
		List<Message> ms = Message.findAll();
		if ( ms.size() > 0 ) {
			render(ms);
		}
	}
	
}
