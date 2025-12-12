-- 24520602 -- Nguyễn Duy Hưng

CREATE DATABASE QlyNCKH;

USE QlyNCKH;

CREATE TABLE PHONG 
(
    MaPhong VARCHAR(10) PRIMARY KEY,
    TenPhong NVARCHAR(50),
    NhiemVu NVARCHAR(100),
    MaTrP VARCHAR(10)
);

CREATE TABLE NHANVIEN
(
    MaNV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(50),
    DiaChi NVARCHAR(100),
    Email VARCHAR(50), 
    GioiTinh TINYINT,
    SoDT VARCHAR(10),
    DanToc NVARCHAR(20),
    MaPhong VARCHAR(10) FOREIGN KEY REFERENCES PHONG(MaPhong)
);

ALTER TABLE PHONG ADD CONSTRAINT FK_PHONG_TRP FOREIGN KEY (MaTrP) REFERENCES NHANVIEN(MaNV);

CREATE TABLE DETAI
(
    MaDT VARCHAR(10) PRIMARY KEY,
    TenDT NVARCHAR(100),
    TomTat NVARCHAR(255), 
    LoaiDT NVARCHAR(5),
    KinhPhi INT,
    NgayBD DATE,
    NgayKT DATE,
    NghiemThu TINYINT
);

CREATE TABLE THAMGIADT 
(
    MaNV VARCHAR(10) FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    MaDT VARCHAR(10) FOREIGN KEY REFERENCES DETAI(MaDT),
    VaiTroDT NVARCHAR(20),
    DongGopDT INT,
    PRIMARY KEY(MaNV, MaDT)
);

CREATE TABLE BAIBAOKH
(
    MaBB VARCHAR(10) PRIMARY KEY,
    TenBB NVARCHAR(100),
    NhaXB NVARCHAR(50),
    NgayCN DATE,
    NgayCB DATE,
    Hang VARCHAR(5),
    LoaiBB NVARCHAR(20),
    MaDT VARCHAR(10) FOREIGN KEY REFERENCES DETAI(MaDT)
);

CREATE TABLE CONGBOBB 
(
    MaNV VARCHAR(10) FOREIGN KEY REFERENCES NHANVIEN(MaNV),
    MaBB VARCHAR(10) FOREIGN KEY REFERENCES BAIBAOKH(MaBB),
    VaiTroBB NVARCHAR(50),
    DongGopBB TINYINT,
    PRIMARY KEY(MaNV, MaBB)
);

INSERT INTO PHONG (MaPhong, TenPhong, NhiemVu, MaTrP) VALUES
('P001','Phòng CNTT','Quản lý CNTT',NULL),
('P002','Phòng KHTN','Nghiên cứu',NULL),
('P003','Phòng HTTT','Quản lý hệ thống',NULL),
('P004','Phòng Điện tử','Nghiên cứu điện tử',NULL),
('P005','Phòng Toán tin','Giảng dạy & nghiên cứu',NULL);

INSERT INTO NHANVIEN VALUES
('NV001','Nguyễn Văn A','TP.HCM','a@uit.edu.vn',1,'0901111111','Kinh','P001'),
('NV002','Trần Thị B','Biên Hòa','b@uit.edu.vn',0,'0902222222','Kinh','P002'),
('NV003','Lê Văn C','Long An','c@uit.edu.vn',1,'0903333333','Kinh','P003'),
('NV004','Phạm Thị D','Đà Nẵng','d@uit.edu.vn',0,'0904444444','Kinh','P004'),
('NV005','Hoàng Văn E','Bình Dương','e@uit.edu.vn',1,'0905555555','Kinh','P005');

UPDATE PHONG SET MaTrP = 'NV001' WHERE MaPhong='P001';
UPDATE PHONG SET MaTrP = 'NV002' WHERE MaPhong='P002';
UPDATE PHONG SET MaTrP = 'NV003' WHERE MaPhong='P003';
UPDATE PHONG SET MaTrP = 'NV004' WHERE MaPhong='P004';
UPDATE PHONG SET MaTrP = 'NV005' WHERE MaPhong='P005';

INSERT INTO DETAI VALUES
('DT01','Nghiên cứu AI','Tóm tắt đề tài AI','A',200000000,'2023-01-01','2023-12-31',1),
('DT02','Phân tích dữ liệu','Tóm tắt Big Data','B',150000000,'2023-02-01','2023-10-30',0),
('DT03','Nhận dạng ảnh','Tóm tắt Image Processing','C',180000000,'2022-05-10','2023-05-10',1),
('DT04','Blockchain','Tóm tắt Blockchain','A',250000000,'2023-03-01','2024-03-01',0),
('DT05','IoT thông minh','Tóm tắt IoT','B',120000000,'2022-11-01','2023-11-01',1);

INSERT INTO THAMGIADT VALUES
('NV001','DT01','Chủ nhiệm',50),
('NV002','DT01','Thành viên',20),
('NV003','DT02','Chủ nhiệm',60),
('NV004','DT03','Thư ký',30),
('NV005','DT04','Thành viên',40);

INSERT INTO BAIBAOKH VALUES
('BB01','Bài báo AI','Springer','2023-07-01','2023-08-01','A*','Tạp chí quốc tế','DT01'),
('BB02','Bài báo IoT','IEEE','2023-06-05','2023-07-10','A','Tạp chí quốc tế','DT05'),
('BB03','Xử lý ảnh','Nature','2023-04-02','2023-05-01','A','Tạp chí quốc tế','DT03'),
('BB04','Blockchain','Elsevier','2023-10-01','2023-11-01','B','Hội nghị quốc tế','DT04'),
('BB05','Phân tích dữ liệu','ACM','2023-02-15','2023-03-01','C','Hội nghị trong nước','DT02');

INSERT INTO CONGBOBB VALUES
('NV001','BB01','Tác giả chính',70),
('NV002','BB02','Tác giả liên hệ',50),
('NV003','BB03','Đồng tác giả',30),
('NV004','BB04','Tác giả chính',60),
('NV005','BB05','Đồng tác giả',40);

-- Đề 1

-- 1.1
GO
CREATE TRIGGER Update_DeTai
ON DETAI
AFTER UPDATE
AS 
BEGIN
    IF (UPDATE(LoaiDT) OR UPDATE(NghiemThu))
    BEGIN 
        IF EXISTS (
            SELECT 1
            FROM INSERTED I
            WHERE I.LoaiDT IN ('A', 'B', 'C')
            AND I.NghiemThu = 1
            AND (
                SELECT COUNT(*) FROM BAIBAOKH B WHERE B.MaDT = I.MaDT
                ) < 2
        )
        BEGIN
            ROLLBACK TRANSACTION
            PRINT ('Đề tài cấp ĐHQG-HCM đã nghiệm thu phải có tối thiểu 2 bài báo.')
        END
    END
END

GO
CREATE TRIGGER Delete_BaiBao
ON BAIBAOKH
AFTER DELETE 
AS
BEGIN
    IF EXISTS (
       SELECT D.MaDT
       FROM DETAI D
       JOIN DELETED DEL ON D.MaDT = DEL.MaDT
       WHERE D.NghiemThu = 1
       AND D.LoaiDT IN ('A', 'B', 'C')
       AND (
           SELECT COUNT(*) FROM BAIBAOKH B
           WHERE B.MaDT = D.MaDT
           ) < 2
    )
    BEGIN 
        ROLLBACK TRANSACTION;
        PRINT ('Đề tài cấp ĐHQG-HCM đã nghiệm thu phải có tối thiểu 2 bài báo.');
    END
END

GO
CREATE TRIGGER Update_BaiBao
ON BAIBAOKH
AFTER UPDATE 
AS
BEGIN
    IF UPDATE(MaDT)
    BEGIN
        IF EXISTS (
           SELECT D.MaDT
           FROM DETAI D
           JOIN DELETED DEL ON D.MaDT = DEL.MaDT
           WHERE D.NghiemThu = 1
           AND D.LoaiDT IN ('A', 'B', 'C')
           AND (
               SELECT COUNT(*) FROM BAIBAOKH B
               WHERE B.MaDT = D.MaDT
               ) < 2
        )
        BEGIN 
            ROLLBACK TRANSACTION;
            PRINT ('Đề tài cấp ĐHQG-HCM đã nghiệm thu phải có tối thiểu 2 bài báo.');
        END
    END
END

-- 1.2.a
SELECT MaNV, HoTen, TenPhong 
FROM NHANVIEN 
JOIN PHONG ON NHANVIEN.MaPhong = PHONG.MaPhong 
WHERE NhiemVu = 'Nghiên cứu'
ORDER BY MaNV DESC

-- 1.2.b
SELECT NHANVIEN.MaNV, HoTen, LoaiDT 
FROM NHANVIEN 
JOIN THAMGIADT ON NHANVIEN.MaNV = THAMGIADT.MaNV 
JOIN DETAI ON THAMGIADT.MaDT = DETAI.MaDT
WHERE YEAR(NgayBD) = '2023' AND VaiTroDT = N'chủ nhiệm'

-- 1.2.c
(SELECT NHANVIEN.MaNV, HoTen 
FROM NHANVIEN 
JOIN CONGBOBB ON NHANVIEN.MaNV = CONGBOBB.MaNV)
EXCEPT
(SELECT NHANVIEN.MaNV, HoTen 
FROM NHANVIEN 
JOIN CONGBOBB ON NHANVIEN.MaNV = CONGBOBB.MaNV 
WHERE VaiTroBB = N'tác giá chính')  

-- 1.2.d
SELECT BAIBAOKH.MaDT, TenDT, COUNT(BAIBAOKH.MaDT) AS SOLUONGBAIBAO 
FROM DETAI 
JOIN BAIBAOKH ON BAIBAOKH.MaDT = DETAI.MaDT
WHERE YEAR(NgayCB) = '2023'
GROUP BY BAIBAOKH.MaDT, TenDT

-- 1.2.e
SELECT HoTen 
FROM NHANVIEN
JOIN CONGBOBB ON NHANVIEN.MaNV = CONGBOBB.MaNV
JOIN BAIBAOKH ON CONGBOBB.MaBB = BAIBAOKH.MaBB
WHERE LoaiBB = N'tạp chí quốc tế' AND MaDT = 'DT01'
GROUP BY HoTen 
HAVING COUNT(HoTen) = (SELECT COUNT(*) FROM BAIBAOKH WHERE LoaiBB = N'tạp chí quốc tế' AND MaDT = 'DT01')

-- 1.2.f
SELECT NV.MaNV, NV.HoTen, P.TenPhong
FROM NHANVIEN NV
JOIN PHONG P ON NV.MaPhong = P.MaPhong
JOIN THAMGIADT TG ON NV.MaNV = TG.MaNV
GROUP BY NV.MaNV, NV.HoTen, P.TenPhong, NV.MaPhong
HAVING COUNT(TG.MaDT) = (
    SELECT MIN(SoLuong)
    FROM (
        SELECT COUNT(TG2.MaDT) AS SoLuong
        FROM NHANVIEN NV2
        JOIN THAMGIADT TG2 ON NV2.MaNV = TG2.MaNV
        WHERE NV2.MaPhong = NV.MaPhong   
        GROUP BY NV2.MaNV
    ) AS SUB
)

-- Đề 2

-- 2.1
GO
CREATE TRIGGER TRG_Update_DeTai
ON DETAI
AFTER UPDATE
AS
BEGIN
    IF UPDATE(LoaiDT) OR UPDATE(KinhPhi)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM INSERTED I
            WHERE I.LoaiDT IN ('D1','D2','D3')
              AND I.KinhPhi > 100000000
              AND (SELECT COUNT(*)
                   FROM THAMGIADT T
                   WHERE T.MaDT = I.MaDT) < 5
        )
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT N'Đề tài cấp trường có kinh phí > 100 triệu phải có tối thiểu 5 nhân viên tham gia.';
        END
    END
END

GO
CREATE TRIGGER TRG_Delete_ThamGia
ON THAMGIADT
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DELETED D
        JOIN DETAI DT ON DT.MaDT = D.MaDT
        WHERE DT.LoaiDT IN ('D1','D2','D3')
          AND DT.KinhPhi > 100000000
          AND (SELECT COUNT(*)
               FROM THAMGIADT T
               WHERE T.MaDT = D.MaDT) < 5
    )
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT N'Đề tài cấp trường có kinh phí > 100 triệu phải có tối thiểu 5 nhân viên tham gia.';
    END
END


-- 2.2.a
SELECT NHANVIEN.MaNV, HoTen, MaDT 
FROM NHANVIEN 
JOIN THAMGIADT ON NHANVIEN.MaNV = THAMGIADT.MaNV
WHERE VaiTroDT = N'chủ nhiệm'
ORDER BY NHANVIEN.MaNV ASC

-- 2.2.b
SELECT NHANVIEN.MaNV, HoTen, Hang
FROM NHANVIEN
JOIN CONGBOBB ON NHANVIEN.MaNV = CONGBOBB.MaNV
JOIN BAIBAOKH ON BAIBAOKH.MaBB = CONGBOBB.MaBB
WHERE LoaiBB = N'tạp chí quốc tế' AND VaiTroBB = 'tác giả chính'

-- 2.2.c
(SELECT MaNV
 FROM CONGBOBB
 WHERE VaiTroBB = N'tác giả chính')
INTERSECT
(SELECT MaNV
 FROM CONGBOBB
 WHERE VaiTroBB = N'đồng tác giả');

-- 2.2.d
SELECT NHANVIEN.MaNV, HoTen, COUNT(MaDT) AS SOLUONGDETAI
FROM NHANVIEN
JOIN THAMGIADT ON NHANVIEN.MaNV = THAMGIADT.MaNV
WHERE VaiTroDT = N'chủ nhiệm'
GROUP BY NHANVIEN.MaNV, HoTen

-- 2.2.e
SELECT HoTen
FROM NHANVIEN
JOIN CONGBOBB ON NHANVIEN.MaNV = CONGBOBB.MaNV
JOIN BAIBAOKH ON CONGBOBB.MaBB = BAIBAOKH.MaBB
WHERE LoaiBB = N'hội nghị quốc tế' AND MaDT = 'DT02'
GROUP BY HoTen
HAVING COUNT(*) = (SELECT COUNT(*) FROM BAIBAOKH WHERE LoaiBB = N'hội nghị quốc tế' AND MaDT = 'DT02')

-- 2.2.f
SELECT NV1.MaNV, NV1.HoTen, P.TenPhong
FROM NHANVIEN NV1
JOIN PHONG P ON NV1.MaPhong = P.MaPhong
JOIN CONGBOBB CB1 ON CB1.MaNV = NV1.MaNV
GROUP BY NV1.MaNV, NV1.HoTen, P.TenPhong, NV1.MaPhong
HAVING COUNT(CB1.MaBB) = (
    SELECT MIN(SoLuong)
    FROM(SELECT COUNT(CB2.MaBB) AS SoLuong
        FROM NHANVIEN NV2
        JOIN CONGBOBB CB2 ON CB2.MaNV = NV2.MaNV
        WHERE NV2.MaPhong = NV1.MaPhong
        GROUP BY NV2.MaNV
    ) AS SUB
)