/*
 * The MIT License
 * 
 * Copyright (c) 2009, 2010 Leif Singer
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

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
		suspend(50);
	}
	
	public static void list() {
		List<Message> ms = Message.findAll();
		if ( ms.size() > 0 ) {
			render(ms);
		}
	}
	
}
