---
menuCode: MST_WAREHOUSE
audience: user
title: Quản lý Kho/Vị trí
summary: Màn hình đăng ký và quản lý master kho và vị trí chi tiết trong kho
tags: [thông tin cơ bản, kho, vị trí, tồn kho]
keywords: [kho, mã kho, tên kho, loại kho, vị trí, vị trí xếp, vị trí chi tiết, zone, khu vực, rack, hàng, cột, tầng, kho mặc định, kho nguyên vật liệu, kho bán thành phẩm, kho thành phẩm, đang sản xuất, kho lỗi, kho hủy, nhà gia công]
related: [MST_PART]
---

# Quản lý Kho/Vị trí

## Mục đích màn hình
Đăng ký và quản lý **kho** nơi tồn kho được lưu trữ và di chuyển, và **vị trí xếp chi tiết (vị trí)** trong kho. Kho/vị trí đã đăng ký tại đây là cơ sở cho nhập kho, cấp phát, tồn kho, sản lượng sản xuất, di chuyển tồn kho.

## Bố cục màn hình
Hai tab ở phía trên chia thành 2 khu vực. Nút (làm mới/đăng ký) ở góc phải trên thay đổi theo tab đã chọn.

- **Tab Quản lý Kho**: Danh sách master kho (grid bên trái) + tìm kiếm và lọc loại kho. ✏️(sửa)/🗑️(xóa) trên hàng, **Đăng ký mới** ở góc phải trên. Click để mở modal đăng ký/sửa.
- **Tab Vị trí**: Danh sách vị trí chi tiết trong kho + lọc kho. Đăng ký/sửa/xóa vị trí.

Mối quan hệ hai khu vực:
```
Kho (WAREHOUSES)
  └─ Vị trí (WAREHOUSE_LOCATIONS)  : Nhiều vị trí chi tiết trong một kho
```

---

## ① Tab Quản lý Kho — Cột / Trường form

| Cột / Trường | Vai trò / Ý nghĩa |
|------|------|
| **Mã kho(warehouseCode)** | **Mã duy nhất** để nhận dạng kho. Không thể thay đổi sau khi đăng ký (tồn kho, sản lượng kết nối qua mã này). |
| **Tên kho(warehouseName)** | Tên kho để nhận dạng tại hiện trường. |
| **Loại kho(warehouseType)** | Phân loại mục đích sử dụng của kho. Phương thức xử lý nhập kho, tồn kho, sản xuất thay đổi theo giá trị này. Giá trị: Kho nguyên vật liệu (RAW) · Kho bán thành phẩm (WIP) · Kho thành phẩm (FG) · Đang sản xuất (FLOOR) · Kho lỗi (DEFECT) · Kho hủy (SCRAP) · Nhà gia công (SUBCON). |
| **Dây chuyền(lineCode)** | Dây chuyền sản xuất mà kho **Đang sản xuất (FLOOR)** trực thuộc. Chỉ nhập khi loại là FLOOR. |
| **Công đoạn(processCode)** | Công đoạn mà kho **Đang sản xuất (FLOOR)** trực thuộc. Chỉ nhập khi loại là FLOOR. |
| **Mặc định(isDefault)** | Có phải là kho mặc định sử dụng trong cùng loại không. Khi tự động nhập/xếp, kho mặc định theo loại được ưu tiên chọn. |
| **Sử dụng(useYn)** | Chỉ là đối tượng tra cứu, chọn, sử dụng khi `Y`. Ngừng sử dụng là `N`. |

> Chỉ khi loại kho là **Đang sản xuất (FLOOR)** mới xuất hiện ô nhập dây chuyền và công đoạn. Các loại khác không sử dụng dây chuyền/công đoạn.

## ② Tab Vị trí — Cột / Trường form

Có thể đặt nhiều vị trí (bin/rack/shelf, v.v.) trong một kho.

| Cột / Trường | Vai trò / Ý nghĩa |
|------|------|
| **Kho(warehouseCode)** | Kho mà vị trí này trực thuộc. Không thể thay đổi sau khi đăng ký. |
| **Mã vị trí(locationCode)** | Mã nhận dạng vị trí chi tiết trong kho. Không thể thay đổi sau khi đăng ký (tổ hợp kho + mã vị trí là duy nhất). |
| **Tên vị trí(locationName)** | Tên vị trí để nhận dạng tại hiện trường. |
| **Zone (Khu vực)(zone)** | Giá trị phân chia khu vực (zone) trong kho. |
| **Hàng(rowNo)** | Số hàng (row) của rack/kệ. |
| **Cột(colNo)** | Số cột (column) của rack/kệ. |
| **Tầng(levelNo)** | Số tầng (level) của rack/kệ. |
| **Sử dụng(useYn)** | Chỉ là đối tượng sử dụng khi `Y` (hiển thị với ● chấm xanh trong danh sách). |
| **Ghi chú(remark)** | Tham khảo quản lý vị trí. |

---

## Trình tự thực hiện
1. Trong **tab Quản lý Kho**, click **Đăng ký mới** ở góc phải trên để tạo kho (bắt buộc: mã kho, tên kho, loại kho; nếu FLOOR thì thêm dây chuyền, công đoạn).
2. Nếu cần, đăng ký vị trí chi tiết (zone/hàng/cột/tầng) cho kho đó trong **tab Vị trí**.
3. Chỉ định kho sẽ dùng cho tự động xếp theo loại bằng cách check **Mặc định**.

## Quy tắc nhập / Kiểm tra
- Mã kho, mã vị trí không thể thay đổi sau khi đăng ký (ô mã bị vô hiệu khi sửa).
- Không thể đăng ký trùng lặp cùng mã kho, cùng tổ hợp (kho + vị trí).
- **Không thể xóa kho còn tồn kho.**

## Câu hỏi thường gặp
- **H.** Ô dây chuyền/công đoạn không hiển thị.
  **Đ.** Phải chọn loại kho là **Đang sản xuất (FLOOR)** để ô nhập dây chuyền và công đoạn xuất hiện.
- **H.** Không thể xóa kho.
  **Đ.** Nếu kho đó còn tồn kho, việc xóa bị từ chối. Hãy dọn sạch tồn kho rồi thử lại hoặc chuyển sử dụng thành `N` để vô hiệu hóa.

## Màn hình liên quan
- [Master Mặt hàng](/master/part) — Thiết lập vị trí xếp mặc định theo mặt hàng
