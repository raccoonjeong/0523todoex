package org.zerock.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class TodoVO {

	private Integer tno;
	private String content;
	private Date regdate;
}
