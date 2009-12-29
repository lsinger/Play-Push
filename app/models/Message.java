package models;

import java.util.Calendar;

import javax.persistence.Entity;

import play.db.jpa.Model;

@Entity
public class Message extends Model {
	
	public String sender;
	public String body;
	public Long ts;
	
	public Message() {
		this.ts = Calendar.getInstance().getTimeInMillis() / 1000;
	}
	
}
